require 'net/http'
require 'openssl'
require 'uri'

# == Schema Information
#
# Table name: assessments
#
#  id            :bigint           not null, primary key
#  topic         :string           not null
#  num_questions :integer          default(5), not null
#  advanced      :boolean          default(FALSE), not null
#  content       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Assessment < ApplicationRecord
  validates :topic, :presence => true, :uniqueness => true
  validates_inclusion_of :advanced, :in => [true, false]
  validates_numericality_of :num_questions, :integer_only => true, :greater_than_or_equal_to => 3

  def has_content?
    if self.content.blank?
      false
    else
      self.content.include?('"question"')
    end
  end

  def question_display
    if self.content.blank?
      ""
    else
      obj = JSON.parse(self.content)
      result = ''
      obj.each do |q|
        result += "#{q['question']}<br>"
      end

      result
    end
  end

  def notify_test_added
    base_url = ENV['METACERT_EXPRESS_ENDPOINT']

    url = URI.parse("#{base_url}/addtest")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    # Prepare the request
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/json'
    request.body = "{\"id\": \"#{self.id}\"}"
    
    response = http.request(request)
    puts response.read_body
  end
end
