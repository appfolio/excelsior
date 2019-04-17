class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
    @appreciations_received = @user.appreciations_received.index
    @appreciations_sent = @user.appreciations_sent.index

    @feedback_received = @user.feedback_received.index
    @feedback_sent = @user.feedback_sent.index
    if !current_user.admin? && @user != current_user
      @feedback_received = @feedback_received.where(:submitter => current_user)
      @feedback_sent = @feedback_sent.where(:recipient => current_user)
    end
  end

  def new
    @user = User.new
  end

  # # GET /users/1/edit
  # def edit
  # end
  #

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, :notice => 'User was successfully created.'
    else
      render :new
    end
  end

  # # PATCH/PUT /users/1
  # def update
  #   if @user.update(user_params)
  #     redirect_to @user, notice: 'User was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end
  #

  def destroy
    notice = nil
    if current_user.admin?
      @user.hide!
      notice = 'User was successfully hidden.'
    end
    redirect_to users_url, notice: notice || 'There was a problem hiding the user.'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :nickname)
    end
end
