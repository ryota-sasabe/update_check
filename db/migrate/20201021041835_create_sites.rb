class CreateSites < ActiveRecord::Migration[6.0]
  def change
    create_table :sites do |t|
      t.string :name, null: false, default: ''
      t.text :delete_patterns
      t.text :exclude_patterns

      t.timestamps
    end
  end
end
