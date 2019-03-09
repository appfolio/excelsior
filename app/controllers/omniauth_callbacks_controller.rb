class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

    @user.save!
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
    sign_in_and_redirect @user, :event => :authentication

  rescue => e
    message = @user ? @user.errors.full_messages.join('<br />').html_safe : e.message
    flash[:alert] = "We got the following errors trying to log you in: #{message}"
    redirect_to new_user_session_url
  end
end
