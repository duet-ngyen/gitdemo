class RevisionsController < ApplicationController
  def index
    @document = Document.find_by(id: params[:document_id])
    @revisions = @document.revisions.order(id: :desc)
    @current_revision = @document.revisions.find_by(version_id: params[:current_revision])
    @previous_revision = @document.revisions.order(:version_id).
      limit(params[:current_revision]).last(2).first
  end

  def show
    @compare_with_previous = params[:compare_with_previous]
    if @compare_with_previous == "true"
      @document = Document.find_by(id: params[:document_id])
      @current_revision = @document.revisions.find_by(version_id: params[:id])
      @previous_revision = @document.revisions.order(:version_id).
        limit(params[:id]).last(2).first
      if @current_revision.version_id > 1
        @change_title = Differ.diff_by_line(@previous_revision.title,
          @current_revision.title).format_as(:html)
        # binding.pry

        @change_description = Differ.diff_by_line(@current_revision.description,
          @previous_revision.description).format_as(:html)
      end
    end
  end
end
