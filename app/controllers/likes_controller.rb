class LikesController < ApplicationController

  def create
    message = Message.find(params[:message_id])
    user = User.find(params[:user_id])
    Like.create(:message => message, :user => user)

    render :json => message.likes(true).count
  end

  def destroy

  end

end
