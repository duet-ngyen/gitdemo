class ComparesController < ApplicationController
  def index
    @document = Document.find_by(id: params[:document_id])
    @current_revision = @document.revisions.find_by(version_id: params[:revision_id])
    @previous_revision = @document.revisions.order(:version_id).
      limit(params[:revision_id]).last(2).first

    if @current_revision.version_id > 1
      @change_title = Diffy::Diff.new(@current_revision.title,
        @current_revision.title).to_s(:html_simple)

      @change_description = Diffy::Diff.new(@previous_revision.description,
        @current_revision.description).to_s(:html_simple)
    end
  end
end
