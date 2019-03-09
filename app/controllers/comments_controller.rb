class CommentsController < ApplicationController

  def create
    root_message = Message.find_by_id!(params[:comment][:root_id])
    @comment = Comment.new(reply_params)

    @comment.submitter = current_user

    @comment.recipient = (root_message.submitter == current_user) ? root_message.recipient : root_message.submitter

    if @comment.save
      ::EmailSender.new(@comment).send_email_and_set_flash
    end

    @root_message = root_message.reload

    #no validation errors shown because the only one possible is an empty message
    respond_to do |format|
      format.html { redirect_to root_message }
      format.js
    end
  end

  def destroy
    if current_user.admin?
      @comment = Message.find_by_id(params[:id])
      root_message = Message.find_by_id(@comment.root_id)
      @comment.hide!

      respond_to do |format|
        format.html { redirect_to root_message }
        format.js
      end
    else
      render :nothing => true
    end
  end

  private

    def reply_params
      params[:comment].permit(:root_id, :message, :anonymous)
    end
end
