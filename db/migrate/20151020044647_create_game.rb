class CreateGame < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.boolean :over, :default => false

      t.timestamps null: false
    end

    create_table :players do |t|
      t.string :status

      t.timestamps null: false
    end

    create_table :boards do |t|

      t.timestamps null: false
    end

    create_table :cells do |t|
      t.integer :row
      t.integer :column
      t.integer :hidden, :default => true

      t.timestamps null: false
    end

    create_table :ships do |t|
      t.boolean :sunk, :default => false

      t.timestamps null: false
    end
  end
end
