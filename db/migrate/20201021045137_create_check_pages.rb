class CreateCheckPages < ActiveRecord::Migration[6.0]
  def change
    create_table :check_pages do |t|
      t.references :site
      t.string :url, null: false, default: ''
      t.text :memo
      t.integer :enabled, null: false, default: 0

      t.timestamps
    end
  end
end
