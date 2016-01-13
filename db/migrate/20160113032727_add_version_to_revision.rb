class AddVersionToRevision < ActiveRecord::Migration
  def change
    add_column :revisions, :version_id, :integer
  end
end
