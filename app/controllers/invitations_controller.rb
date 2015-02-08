class InvitationsController < ApplicationController
  include CreateInvitation

  before_action :ensure_authenticated, except: %i(show accept)

  before_action do
    @provider = Provider.find(params[:provider_id]) if params[:provider_id]
  end

  def index
    check_access!('admin:invitations:list')
    @invitations = Invitation.all
    @providers = Provider.all
  end

  def new
    check_access!("providers:#{@provider.id}:invitations:create")
    @invitation = Invitation.new
  end

  def create
    check_access!("providers:#{@provider.id}:invitations:create")

    create_invitation(@provider, invitation_params)
    redirect_to(provider_provided_attributes_path(@provider))
  end

  def show
    public_action
    @invitation = Invitation.where(identifier: params[:identifier]).first!

    render('used') && return if @invitation.used?
    render('expired') && return if @invitation.expired?
  end

  def accept
    public_action

    Invitation.available.where(identifier: params[:identifier]).first!
    session[:invite] = params[:identifier]
    redirect_to('/auth/login')
  end

  private

  def invitation_params
    params.require(:invitation).permit(:name, :mail)
  end

  def create_invitation(provider, attrs)
    if Subject.exists?(attrs.slice(:mail))
      flash[:error] = 'Invitation cannot be sent as an account for ' \
                      "#{attrs[:mail]} already exists."
    else
      super
      flash[:success] = "Invitation to #{attrs[:name]} has been sent."
    end
  end
end
