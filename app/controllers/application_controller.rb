class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :expire_hsts
  before_filter :authenticate_user!

  private

  def set_recipients
    @recipients ||=  User.index.sort { |a, b| a.name <=> b.name }.map {|u| { label: u.name, value: u.id }}
  end

  def expire_hsts
    response.headers["Strict-Transport-Security"] = 'max-age=0'
  end
end
