require 'openai_chat'

class AssessmentsController < ApplicationController
  include ApplicationHelper

  respond_to :html

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
    
    redirect_to tests_path, :notice => 'Test successfully deleted'    
  end
  
private
  def test_params
    puts params
    params.require(:assessment).permit(:topic, :content, :num_questions, :advanced)
  end
end