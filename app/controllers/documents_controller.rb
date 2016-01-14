class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index
    @documents = Document.all
  end

  def show
  end

  def new
    @document = Document.new
  end

  def edit
  end

  def create
    @document = Document.new(document_params)

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end

    @revision = Revision.new(revision_params)
    @revision.save
    @revision.update_attributes(document_id: @document.id, version_id: 1)

  end

  def update
    unless params[:ver_restore].present?
      respond_to do |format|
        if @document.update(document_params)
          format.html { redirect_to @document, notice: 'Document was successfully updated.' }
          format.json { render :show, status: :ok, location: @document }
        else
          format.html { render :edit }
          format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      end

      @revision = Revision.new(revision_params)
      @revision.save
      version_id = Revision.where(document_id: params[:id]).order(id: :desc).first.version_id
      @revision.update_attributes(document_id: params[:id], version_id: version_id + 1)
    else
      binding.pry
      @document = Document.find_by id: params[:id]
      @restore_revision = Revision.find_by(id: params[:ver_restore])
      @document.update_attributes(title: @restore_revision.title,
        description: @restore_revision.description)
      Revision.create(title: @restore_revision.title, description: @restore_revision.description,
         document_id: params[:id], version_id: @document.revisions.last.version_id.to_i + 1)
      redirect_to @document
    end
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def restore
    binding.pry
    @document = Document.find_by(id: params[:document_id])

    redirect_to documents_path
  end

  private
    def set_document
      @document = Document.find(params[:id])
    end

    def document_params
      params.require(:document).permit(:title, :description)
    end

    def revision_params
      params.require(:document).permit(:title, :description)
    end
end
