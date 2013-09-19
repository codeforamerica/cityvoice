class AppContentSetsController < ApplicationController
  before_action :set_app_content_set, only: [:show, :edit, :update, :destroy]

  # GET /app_content_sets
  # GET /app_content_sets.json
  def index
    @app_content_sets = AppContentSet.all
  end

  # GET /app_content_sets/1
  # GET /app_content_sets/1.json
  def show
  end

  # GET /app_content_sets/new
  def new
    @app_content_set = AppContentSet.new
  end

  # GET /app_content_sets/1/edit
  def edit
  end

  # POST /app_content_sets
  # POST /app_content_sets.json
  def create
    @app_content_set = AppContentSet.new(app_content_set_params)

    respond_to do |format|
      if @app_content_set.save
        format.html { redirect_to @app_content_set, notice: 'App content set was successfully created.' }
        format.json { render action: 'show', status: :created, location: @app_content_set }
      else
        format.html { render action: 'new' }
        format.json { render json: @app_content_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_content_sets/1
  # PATCH/PUT /app_content_sets/1.json
  def update
    respond_to do |format|
      if @app_content_set.update(app_content_set_params)
        format.html { redirect_to @app_content_set, notice: 'App content set was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @app_content_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_content_sets/1
  # DELETE /app_content_sets/1.json
  def destroy
    @app_content_set.destroy
    respond_to do |format|
      format.html { redirect_to app_content_sets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_content_set
      @app_content_set = AppContentSet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_content_set_params
      params.require(:app_content_set).permit(:issue, :learn_text, :call_text, :call_instruction, :app_phone_number, :listen_text, :message_from, :message_url)
    end
end
