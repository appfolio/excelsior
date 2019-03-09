class FeedbacksController < ApplicationController
  include ::MessagesUtils

  def show
    @feedback = Feedback.find(params[:id])

    if current_user != @feedback.recipient &&
       current_user != @feedback.submitter &&
       !current_user.admin?
      flash[:notice] = "You don't have permission to see that feedback."
      redirect_to appreciations_path and return
    end

    set_received_at(@feedback)
  end

  def new
    set_recipients
    @feedback = Feedback.new
    if params[:recipient_id].present? && recipient = User.find_by_id(params[:recipient_id])
      @feedback.recipient_id = recipient.id
      @recipient_name = recipient.name
    end
  end

  def create
    @feedback = Feedback.new(params[:feedback].permit(:message, :team, :anonymous))
    @feedback.recipient = User.find_by_id(params[:feedback][:recipient_id])
    @feedback.submitter = current_user

    if @feedback.save
      flash = ::EmailSender.new(@feedback).send_email_and_set_flash
      redirect_to @feedback, notice: "Gnice - your feedback was successfully created! #{flash}"
    else
      set_recipients
      render action: "new"
    end
  end

  def destroy
    if current_user.admin?
      Feedback.find(params[:id]).try(&:hide!)
    end

    redirect_to appreciations_url
  end

end
