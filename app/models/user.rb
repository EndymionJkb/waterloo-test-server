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
end
