class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.integer :doc_id
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
