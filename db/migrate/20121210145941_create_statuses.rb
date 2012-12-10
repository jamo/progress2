class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name
      t.integer :tehty, :default => 0
      t.integer :yhteensa, :default => 100

      t.timestamps
    end
  end
end
