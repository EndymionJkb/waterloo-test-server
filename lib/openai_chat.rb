require 'singleton'

class OpenAIChat
  include Singleton

  attr_accessor :client

  def initialize
    client = OpenAI::Client.new(access_token: OPENAI_ACCESS_TOKEN)
  end

  def generate_prompt(topic, num_questions, advanced)
    begin
      # Seems to need this every time?
      client = OpenAI::Client.new(access_token: OPENAI_ACCESS_TOKEN)
      level = advanced ? "advanced" : "simple"

      prompt = "Act as a test question server. That means given a topic statement, please respond with #{num_questions} multiple choice questions about the topic, along with the answers." +
               "Please format this in a JSON file like so: " +
               "[{\"questionId\":\"1\",\"question\":\"How much is 8 * 80?\",\"choices\":[{\"choiceId\":\"1\", \"choice\":\"Less than 10\"},{\"choiceId\":\"2\",\"choice\":\"< 50\"}," +
               "{\"choiceId\":\"3\",\"choice\":\"Greater than 500?\"}],\"answer\":\"3\"}]" +
               "There can be simple questions and advanced questions. For this run, please generate #{level} questions on the topic '#{topic}', each with three possible choices," + 
               "in the format specified above."
      puts prompt

      response = client.completions(
          parameters: {
            model: "text-davinci-003",
            prompt: prompt,
            max_tokens: 3500
          })
      
      @results = response['choices'][0]['text']
    rescue Exception => ex
      @results = "<br><br>#{ex.message}<br><br>#{response}".html_safe
    end
  end
end
