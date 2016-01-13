class ComparesController < ApplicationController
  def index
    @revisions_of_doc = Revision.where(doc_id: params[:document_id])
    @current_revision = Revision.find_by(doc_id: params[:document_id],
      version_id: params[:revision_id])
    @previous_revision = @revisions_of_doc.order(:version_id).
      limit(params[:revision_id].to_i - 1).last

    if @current_revision.version_id > 1
      @change_title = Diffy::Diff.new(@current_revision.title,
        @current_revision.title).to_s(:html_simple)

      @change_description = Diffy::Diff.new(@previous_revision.description,
        @current_revision.description,
        :include_plus_and_minus_in_html => true).to_s(:html_simple)
    end
  end
end
