class CreateTips < ActiveRecord::Migration[5.2]
  def change
    create_table :kt_tips do |t|
      t.string :topic
      t.string :content
      t.datetime :written_on, :required => false
      t.integer :likes, :default => 0
      t.timestamps null: false
    end
  end

  def down
    drop_table :kt_tips
  end
end
