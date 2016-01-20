module RestoreRevision
  def restore_to restore_revision, document
    document.update_attributes(title: restore_revision.title,
      description: restore_revision.description, lastest_revision: document.lastest_revision + 1)
    Revision.create(title: restore_revision.title, description: restore_revision.description,
       document_id: params[:id], version_id: document.revisions.last.version_id.to_i + 1)
    redirect_to document_revisions_path(document.id)
    flash[:warning] = "Document was restored to the same version: #{@restore_revision.version_id}"
  end
end
