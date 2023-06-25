require 'openai_chat'

class AssessmentsController < ApplicationController
  include ApplicationHelper

  respond_to :html

  PASSING_SCORE = 80

  def index
    @tests = Assessment.order(:topic)
  end
  
  def new
    @test = Assessment.new
  end
  
  def create
    @test = Assessment.new(test_params)

    begin
      if @test.save
        redirect_to assessments_path, :notice => 'Test successfully created'
      else
        render 'new'
      end  
    rescue Exception => ex
      @test.errors.add :base, ex.message
      
      render 'new'
    end   
  end
  
  def edit
    @test = Assessment.find(params[:id])
  end
  
  def update
    @test = Assessment.find(params[:id])
    
    begin
      @test.assign_attributes(test_params)
      @test.content = OpenAIChat.instance.generate_prompt(@test.topic, @test.num_questions, @test.advanced)

      if @test.save
        begin
          @test.notify_test_added
        rescue Exception => ex
          puts ex.inspect
        end

        redirect_to assessments_path, :notice => 'Test successfully updated'
      else
        render 'edit'
      end
    rescue Exception => ex
      @test.errors.add :base, ex.message
      
      render 'edit'
    end   
  end
  
  def destroy
    @test = Assessment.find(params[:id])
    @test.destroy
    
    redirect_to assessments_path, :notice => 'Test successfully deleted'    
  end
  
  # Get a list of the tests that are available
  def available_tests
    # id, name
    data = []
    Assessment.order(:topic).each do |a|
      data.push({:id => a.id, :name => a.topic})
    end

    render json: data, content_type: 'application/json'
  end

  # Get the questions for a particular test
  def get_questions
    test_id = params[:id]

    test = Assessment.find_by_id(test_id)
    result = {"ERROR": "Test not found"}

    # Filter out the answers, since this is an open get
    unless test.nil?
      obj = JSON.parse(test.content)
      result = []
      obj.each do |q|
        o = {}
        q.keys.each do |k|
          next if k == 'answer'
          o[k] = q[k]
        end 
        result.push(o)
      end
    end

    render :json => result, content_type: 'application/json'
  end

  # Results are in the form of test id, address of user, [{questionId, choice}]
  def score_test
    puts params

    a = Assessment.find_by_id(params[:id])
    if a.nil?
      status = "ERROR: Test not found"
    else
      user_id = params[:address]

      if user_id.length != 42
        status = "ERROR: Invalid user address"
      else
        user = User.find_by_address(user_id)
        if user.nil?
          user = User.create(:address => user_id)
        end

        n = a.num_questions.to_f
        correct = 0.0

        answer_key = JSON.parse(a.content)
        key = Hash.new
        answer_key.each do |k|
          qid = k["questionId"].to_i
          key[qid] = k["answer"].to_i
        end
        
        # Record the users answers in a hash :answer_id => choice (as numbers)
        answers = Hash.new
        idx = 1
        params[:choices].split(',').each do |choice|
          answers[idx] = choice.to_i
          idx += 1
        end

        if answers.length == n
          answers.keys.each do |k|
            if answers[k] == key[k]
              correct += 1.0
            end
          end

          score = (correct / n * 100.0).round
          passed = score >= PASSING_SCORE
          status = "Success"
          if passed
            begin
              user.mint_poap(a.id)
            rescue Exception => ex
              puts ex.inspect
            end
          end

          user.test_logs.create(:assessment_id => a.id, :score => score, :passed => passed)
        else
          status = "ERROR: Question mismatch; cannot score"
        end
      end
    end

    render :json => {:status => status, :passed => passed}
  end

private
  def test_params
    params.require(:assessment).permit(:topic, :content, :num_questions, :advanced)
  end
end