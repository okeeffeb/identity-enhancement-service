require 'rails_helper'

RSpec.feature 'Visiting the invitation page', type: :feature do
  given(:invitation) { create(:invitation) }

  background do
    attrs = create(:aaf_attributes, displayname: invitation.name,
                                    mail: invitation.mail)

    RapidRack::TestAuthenticator.jwt = create(:jwt, aaf_attributes: attrs)
  end

  scenario 'accepting the invitation' do
    visit "/invitations/#{invitation.identifier}"
    click_button 'Accept'

    expect(current_path).to eq('/auth/login')
    click_button 'Login'

    expect(current_path).to eq('/')
    expect(page).to have_content("Logged in as: #{invitation.name}")
  end

  context 'with a used invitation' do
    given(:invitation) { create(:invitation, used: true) }

    scenario 'attempting to accept the invitation' do
      visit "/invitations/#{invitation.identifier}"
      expect(page).to have_content('invitation has already been used')
    end
  end

  context 'with an expired invitation' do
    given(:invitation) { create(:invitation, expires: 1.day.ago) }

    scenario 'attempting to accept the invitation' do
      visit "/invitations/#{invitation.identifier}"
      expect(page).to have_content('invitation has expired')
    end
  end
end
