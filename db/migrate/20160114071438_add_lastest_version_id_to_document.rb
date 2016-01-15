class AddLastestVersionIdToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :lastest_revision, :integer
  end
end
