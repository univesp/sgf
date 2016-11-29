class UsersController < ApplicationController
  before_action :create_user_identity, only: [:finish_signup]
  before_action :set_user, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def create_user_identity
    @user = User.new
  end

  def update
    @errors = {}
    res = @user.update(user_params)
    respond_to do |format|
      if res && @user.errors.blank?
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(current_user)
    @user.destroy!
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [:name, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, 
                    :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip,
                    :confirmation_token, :confirmed_at, :confirmed_at, :confirmation_sent_at, :uncorfirmed_email]
      params.permit(accessible)
    end
end
