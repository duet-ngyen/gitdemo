class RevisionsController < ApplicationController
  def index
    @document = Document.find_by(id: params[:document_id])
    @revisions = @document.revisions.order(id: :desc)
  end
end
