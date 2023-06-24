# == Schema Information
#
# Table name: test_logs
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  assessment_id :bigint
#  score         :decimal(6, 2)
#  passed        :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :test_log do
    score { "9.99" }
  end
end
