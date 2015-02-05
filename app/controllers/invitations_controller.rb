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

  # rubocop:disable Metrics/AbcSize
  def create
    check_access!("providers:#{@provider.id}:invitations:create")

    if Subject.exists?(invitation_params.slice(:mail))
      flash[:error] = 'Invitation cannot be sent as an account for '\
                      "#{invitation_params[:mail]} already exists."
    else
      create_invitation(@provider, invitation_params)
      flash[:success] = "Invitation to #{invitation_params[:name]} "\
                        'has been sent.'
    end

    redirect_to(provider_provided_attributes_path(@provider))
  end
  # rubocop:enable Metrics/AbcSize

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
end
