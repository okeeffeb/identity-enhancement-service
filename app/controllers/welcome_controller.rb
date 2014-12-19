class WelcomeController < ApplicationController
  skip_before_action :ensure_authenticated

  def index
    subject
    public_action
  end
end
