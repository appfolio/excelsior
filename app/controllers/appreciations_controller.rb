class AppreciationsController < ApplicationController
  include ::MessagesUtils

  # GET /appreciations
  def index
    @appreciations = Appreciation.visible
    if filters = params[:filters]
      @by = User.find_by_id(filters[:submitter_id]).try(:name)
      recipient = User.find_by_id(filters[:recipient_id]).try(:name)
      team = filters[:team] if filters[:team]
      @for = [recipient, team].compact.join(', ')

      @appreciations = @appreciations.where(:submitter_id => filters[:submitter_id]) if filters[:submitter_id]
      @appreciations = @appreciations.where(:recipient_id => filters[:recipient_id]) if filters[:recipient_id]
      @appreciations = @appreciations.where(:team => filters[:team]) if filters[:team]
    end
    @appreciations = @appreciations.page(params[:page]).per_page(50)
  end

  def show
    @appreciation = Appreciation.find(params[:id])
    set_received_at(@appreciation)
  end

  def new
    set_recipients
    @appreciation = Appreciation.new
    if params[:recipient_id].present? && recipient = User.find_by_id(params[:recipient_id])
      @appreciation.recipient_id = recipient.id
      @recipient_name = recipient.name
    end
  end

  def create
    @appreciation = Appreciation.new(params[:appreciation].permit(:message, :team, :anonymous))
    @appreciation.recipient = User.find_by_id(params[:appreciation][:recipient_id])
    @appreciation.submitter = current_user

    if @appreciation.save
      flash = ::EmailSender.new(@appreciation).send_email_and_set_flash
      ::SlackSender.new(@appreciation).send_slack_message
      redirect_to @appreciation, notice: "Awesome - your appreciation was successfully created! #{flash}"
    else
      render action: "new"
    end
  end

  def destroy
    if current_user.admin?
      Appreciation.find(params[:id]).try(&:hide!)
    end

    redirect_to appreciations_url
  end

end
