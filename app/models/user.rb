require 'net/http'

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  address    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  validates_presence_of :address, :uniqueness => true
  
  has_many :test_logs

  def mint_poap(assessment_id)
    base_url = ENV['METACERT_EXPRESS_ENDPOINT']

    url = URI.parse("#{base_url}/issue/cert")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    # Prepare the request
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/json'
    request.body = "{\"address\":\"#{self.address}\",\"courseId\": \"#{assessment_id}\""

    # Send the request and get the response
    response = http.request(request)
    puts response.inspect
  end
end
