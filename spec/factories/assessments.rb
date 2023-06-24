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
FactoryBot.define do
  factory :assessment do
    topic { "MyString" }
    content { "MyText" }
    num_questions { 5 }
    advanced { true }
  end
end
