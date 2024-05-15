class CreateCheckPageResults < ActiveRecord::Migration[6.0]
  def change
    create_table :check_page_results do |t|
      t.references :check_page
      t.integer :revision, null: false
      t.integer :status, null: false
      t.integer :length, null: false
      t.text :body, limit: 16777215
      t.datetime :checked_at

      t.timestamps
    end
    add_index :check_page_results, %i[revision]
  end
end
