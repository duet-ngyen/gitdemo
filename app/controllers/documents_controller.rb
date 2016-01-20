class DocumentsController < ApplicationController
  include Confliction
  include RestoreRevision
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
    $document = Document.find_by(id: params[:id])
    @data = {document: @document}
  end

  def create
    @document = Document.new(document_params)

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
        create_revision(revision_params, 1, @document.id)
        @document.update_attributes(lastest_revision: @document.revisions.last.version_id)
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # @document.test
    unless params[:ver_restore].present?
      if (params[:document][:lastest_revision].to_i + 1) > @document.revisions.last.version_id
        respond_to do |format|
          if @document.update(document_params)
            format.html { redirect_to @document, notice: 'Document was successfully updated.' }
            format.json { render :show, status: :ok, location: @document }
            new_version_id = @document.revisions.last.version_id + 1
            create_revision(revision_params, new_version_id, params[:id])
            @document.update_attributes(lastest_revision: @document.revisions.last.version_id)
          else
            format.html { render :edit }
            format.json { render json: @document.errors, status: :unprocessable_entity }
          end
        end
      else
        if @document.description.strip != params[:document][:description].strip
          @document.description = Differ.diff_by_line(params[:document][:description], @document.description)
          recoginze_conflict @document, @document.description
        else
          flash[:warning] = "Auto merged"
          redirect_to @document
        end
      end
    else
      @restore_revision = Revision.find_by(id: params[:ver_restore])
      restore_to @restore_revision, @document
    end
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_document
      @document = Document.find(params[:id])
    end

    def document_params
      params.require(:document).permit(:title, :description, :lastest_revision)
    end

    def revision_params
      params.require(:document).permit(:title, :description)
    end

    def create_revision params, version_id, document_id
      @revision = Revision.new(params)
      @revision.save
      @revision.update_attributes(document_id: document_id, version_id: version_id)
    end
end
