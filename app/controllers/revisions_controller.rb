class RevisionsController < ApplicationController
  def index
    @revisions = Revision.where(doc_id: params[:document_id]).order(id: :desc)
  end
end
