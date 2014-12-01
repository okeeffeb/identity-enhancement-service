class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  Forbidden = Class.new(StandardError)
  private_constant :Forbidden
  rescue_from Forbidden, with: :forbidden

  after_action { fail('No access control performed') unless @access_checked }

  protected

  def subject
    @subject = session[:subject_id] && Subject.find(session[:subject_id])
  end

  def check_access!(action)
    fail(Forbidden) unless subject.permits?(action)
    @access_checked = true
  end

  def public_action
    @access_checked = true
  end

  def forbidden
    render 'errors/forbidden', status: 403
  end
end
