class FormResponsesController < ApplicationController
  before_action :set_form_response, only: [:show, :edit, :update, :destroy]

  # GET /form_responses
  # GET /form_responses.json
  def index
    @form_responses = FormResponse.all
  end

  # GET /form_responses/1
  # GET /form_responses/1.json
  def show
  end

  # GET /form_responses/new
  def new
    @form_response = FormResponse.new
  end

  # GET /form_responses/1/edit
  def edit
  end

  # POST /form_responses
  # POST /form_responses.json
  def create
    @form_response = FormResponse.new(form_response_params)

    respond_to do |format|
      if @form_response.save
        format.html { redirect_to @form_response, notice: 'Form response was successfully created.' }
        format.json { render :show, status: :created, location: @form_response }
      else
        format.html { render :new }
        format.json { render json: @form_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /form_responses/1
  # PATCH/PUT /form_responses/1.json
  def update
    respond_to do |format|
      if @form_response.update(form_response_params)
        format.html { redirect_to @form_response, notice: 'Form response was successfully updated.' }
        format.json { render :show, status: :ok, location: @form_response }
      else
        format.html { render :edit }
        format.json { render json: @form_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /form_responses/1
  # DELETE /form_responses/1.json
  def destroy
    @form_response.destroy
    respond_to do |format|
      format.html { redirect_to form_responses_url, notice: 'Form response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form_response
      @form_response = FormResponse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_response_params
      params.require(:form_response).permit(:form_id, :user, :status, :json_response, :json_updated_at, :sent_at)
    end
end
