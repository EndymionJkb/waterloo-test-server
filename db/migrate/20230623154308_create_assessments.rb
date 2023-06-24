class CreateAssessments < ActiveRecord::Migration[6.1]
  def change
    create_table :assessments do |t|
      t.string :topic, :null => false
      t.integer :num_questions, :null => false, :default => 5
      t.boolean :advanced, :null => false, :default => false
      t.text :content

      t.timestamps
    end
  end
end
