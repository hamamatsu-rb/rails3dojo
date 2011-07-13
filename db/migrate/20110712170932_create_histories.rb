class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.integer :page_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :histories
  end
end
