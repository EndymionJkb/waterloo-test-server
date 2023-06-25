require 'net/http'

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

  def notify_test_added
    base_url = ENV['METACERT_EXPRESS_ENDPOINT']

    url = URI.parse("#{base_url}/addtest")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = false
    
    # Prepare the request
    request = Net::HTTP::Post.new(url.path)
    request.set_form_data({ id: self.id })
    
    # Send the request and get the response
    response = http.request(request)
    puts response.inspect
  end
end
