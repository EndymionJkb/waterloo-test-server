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
require 'rails_helper'

RSpec.describe Assessment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
