class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  Forbidden = Class.new(StandardError)
  private_constant :Forbidden
  rescue_from Forbidden, with: :forbidden

  SubjectMissing = Class.new(StandardError)
  private_constant :SubjectMissing
  rescue_from SubjectMissing, with: :force_logout

  after_action do
    unless @access_checked
      method = "#{self.class.name}##{params[:action]}"
      fail("No access control performed by #{method}")
    end
  end

  protected

  def subject
    @subject = session[:subject_id] && Subject.find(session[:subject_id])
  rescue ActiveRecord::RecordNotFound
    raise(SubjectMissing)
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

  def bad_request
    render 'errors/bad_request', status: 400
  end

  def require_subject
    subject || redirect_to('/auth/login')
  end

  def force_logout
    redirect_to('/auth/logout')
  end
end
