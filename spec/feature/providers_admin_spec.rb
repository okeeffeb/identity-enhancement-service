require 'rails_helper'

RSpec.feature 'Modifying Providers' do
  given(:user) { create(:subject, :authorized) }
  given!(:provider) { create(:provider) }

  background do
    attrs = create(:aaf_attributes, :from_subject, subject: user)
    RapidRack::TestAuthenticator.jwt = create(:jwt, aaf_attributes: attrs)

    visit '/auth/login'
    click_button 'Login'
  end

  scenario 'viewing the providers list' do
    visit '/admin/providers'
    expect(current_path).to eq('/admin/providers')

    expect(page).to have_css('table tr td', text: provider.name)
  end

  scenario 'viewing a provider' do
    visit '/admin/providers'
    within('table tr', text: provider.name) do
      click_link 'Show'
    end

    expect(page).to have_content(provider.name)
    expect(page).to have_content(provider.identifier)
  end

  scenario 'creating a provider' do
    visit '/admin/providers'
    click_link 'Create'

    expect(current_path).to eq(new_provider_path)
    attrs = attributes_for(:provider)
    within('form') do
      fill_in 'Name', with: attrs[:name]
      fill_in 'Identifier', with: attrs[:identifier]
      fill_in 'Description', with: attrs[:description]
      click_button 'Create'
    end

    expect(current_path).to eq(providers_path)
    expect(page).to have_css('table tr td', text: attrs[:name])
  end

  scenario 'editing a provider' do
    visit '/admin/providers'
    within('table tr', text: provider.name) do
      click_link 'Edit'
    end

    new_name = "New Name #{provider.name}"

    expect(current_path).to eq(edit_provider_path(provider))

    within('form') do
      fill_in 'Name', with: new_name
      click_button 'Save'
    end

    expect(current_path).to eq(providers_path)
    expect(page).to have_css('table tr td', text: new_name)
  end

  scenario 'deleting a provider' do
    visit '/admin/providers'
    within('table tr', text: provider.name) do
      click_link 'Delete'
    end

    expect(current_path).to eq(providers_path)
    expect(page).not_to have_css('table tr td', text: provider.name)
  end
end
