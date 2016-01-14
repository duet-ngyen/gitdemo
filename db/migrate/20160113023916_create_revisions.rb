class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.string :title
      t.text :description
      t.references :document, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
