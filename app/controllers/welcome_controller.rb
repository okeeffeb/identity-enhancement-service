class WelcomeController < ApplicationController
  before_action do
    @subject = session[:subject_id] && Subject.find(session[:subject_id])
    redirect_to('/auth/login') if @subject.nil?
  end

  def index
  end
end
