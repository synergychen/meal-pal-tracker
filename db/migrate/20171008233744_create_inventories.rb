class CreateInventories < ActiveRecord::Migration[5.1]
  def change
    create_table :inventories do |t|
      t.string :schedule_id
      t.date :serve_date
      t.integer :amount
      t.integer :mpn_amount

      t.timestamps
    end
  end
end
