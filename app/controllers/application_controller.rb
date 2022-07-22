class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :expire_hsts
  before_action :authenticate_user!

  private

  def set_recipients
    @recipients ||=  User.visible.sort { |a, b| a.name <=> b.name }.map {|u| { label: u.name, value: u.id }}
  end

  def expire_hsts
    response.headers["Strict-Transport-Security"] = 'max-age=0'
  end
end
