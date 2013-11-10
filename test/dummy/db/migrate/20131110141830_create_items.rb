class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.decimal :price
      t.text :description
      t.integer :order_id
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
