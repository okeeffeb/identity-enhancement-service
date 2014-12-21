require 'rails_helper'

RSpec.feature 'Roles Admin' do
  given(:user) { create(:subject, :authorized) }

  given!(:role) { create(:role) }
  given!(:provider) { role.provider }
  given!(:other_role) { create(:role) }
  given!(:assoc) { create(:subject_role_assignment, role: role) }
  given!(:api_assoc) { create(:api_subject_role_assignment, role: role) }
  given!(:other_subject) { create(:subject) }
  given!(:api_subject) { create(:api_subject) }

  given(:base_path) { "/providers/#{provider.id}" }

  background do
    attrs = create(:aaf_attributes, :from_subject, subject: user)
    RapidRack::TestAuthenticator.jwt = create(:jwt, aaf_attributes: attrs)

    visit '/auth/login'
    click_button 'Login'

    visit '/providers'
    within('tr', text: provider.name) do
      click_link('View')
    end

    click_link('Roles')
    expect(current_path).to eq("#{base_path}/roles")
  end

  scenario 'viewing the role list' do
    expect(page).to have_css('tr td', text: role.name)
    expect(page).to have_no_css('tr td', text: other_role.name)
  end

  scenario 'viewing a role' do
    within('tr', text: role.name) do
      click_link('Members')
    end

    expect(current_path).to eq("#{base_path}/roles/#{role.id}")
    expect(page).to have_css('.header', text: role.name)
    expect(page).to have_css('td', text: assoc.subject.name)
    expect(page).to have_css('td', text: api_assoc.api_subject.name)

    click_link('Back to List')
    expect(current_path).to eq("#{base_path}/roles")
  end

  scenario 'editing a role' do
    within('tr', text: role.name) do
      click_link('Edit')
    end

    expect(current_path).to eq("#{base_path}/roles/#{role.id}/edit")
    expect(page).to have_css('.header', text: role.name)

    new_name = attributes_for(:role)[:name]

    within('form') do
      fill_in 'Name', with: new_name
      click_button('Save')
    end

    expect(page).to have_css('tr td', text: new_name)
  end

  scenario 'creating a role' do
    click_link('New Role')

    expect(current_path).to eq("#{base_path}/roles/new")

    name = attributes_for(:role)[:name]

    within('form') do
      fill_in 'Name', with: name
      click_button('Create')
    end

    expect(current_path).to eq("#{base_path}/roles")
    expect(page).to have_css('tr td', text: name)
  end

  scenario 'deleting a role' do
    within('tr', text: role.name) do
      find('div.ui.button', text: 'Delete').click
      click_link('Confirm Delete')
    end

    expect(current_path).to eq("#{base_path}/roles")
    expect(page).to have_no_css('tr td', text: role.name)
  end

  scenario 'assigning a role to a subject' do
    within('tr', text: role.name) do
      click_link('Members')
    end

    expect(current_path).to eq("#{base_path}/roles/#{role.id}")
    expect(page).to have_no_css('tr', text: other_subject.name)
    click_link('Add Subject')

    expect(current_path).to eq("#{base_path}/roles/#{role.id}/members/new")

    within('tr', text: other_subject.name) do
      click_button('Grant')
    end

    expect(current_path).to eq("#{base_path}/roles/#{role.id}")
    expect(page).to have_css('tr', text: other_subject.name)
  end

  scenario 'revoking a role from a subject' do
    other_subject.subject_role_assignments
      .create!(role: role, audit_comment: 'Granted role for test case')

    within('tr', text: role.name) do
      click_link('Members')
    end

    expect(current_path).to eq("#{base_path}/roles/#{role.id}")
    within('tr', text: other_subject.name) do
      find('div.ui.button', text: 'Revoke').click
      click_link('Confirm Delete')
    end

    expect(current_path).to eq("#{base_path}/roles")
    expect(page).to have_no_css('tr', text: other_subject.name)
  end

  scenario 'assigning a role to an api subject' do
    within('tr', text: role.name) do
      click_link('Members')
    end

    expect(current_path).to eq("#{base_path}/roles/#{role.id}")
    expect(page).to have_no_css('tr', text: api_subject.name)
    click_link('Add API Account')

    expect(current_path).to eq("#{base_path}/roles/#{role.id}/api_members/new")

    within('tr', text: api_subject.name) do
      click_button('Grant')
    end

    expect(current_path).to eq("#{base_path}/roles/#{role.id}")
    expect(page).to have_css('tr', text: api_subject.name)
  end

  scenario 'revoking a role from an api subject' do
    api_subject.api_subject_role_assignments
      .create!(role: role, audit_comment: 'Granted role for test case')

    within('tr', text: role.name) do
      click_link('Members')
    end

    expect(current_path).to eq("#{base_path}/roles/#{role.id}")
    within('tr', text: api_subject.name) do
      find('div.ui.button', text: 'Revoke').click
      click_link('Confirm Delete')
    end

    expect(current_path).to eq("#{base_path}/roles")
    expect(page).to have_no_css('tr', text: api_subject.name)
  end
end
