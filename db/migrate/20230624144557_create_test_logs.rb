class CreateTestLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :test_logs do |t|
      t.references :user
      t.references :assessment
      t.decimal :score, :precision => 6, :scale => 2
      t.boolean :passed

      t.timestamps
    end
  end
end
