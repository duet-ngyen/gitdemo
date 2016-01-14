class RevisionsController < ApplicationController
  def index
    @revisions = Revision.where(document_id: params[:document_id]).order(id: :desc)
    @document = Document.find_by(params[:document_id])
  end
end
