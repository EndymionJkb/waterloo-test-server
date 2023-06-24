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
end
