require 'rails_helper'

RSpec.feature 'Providing attributes to subjects', js: true do
  given(:user) { create(:subject, :authorized) }

  given!(:attribute) { create(:provided_attribute) }
  given(:provider) { attribute.permitted_attribute.provider }
  given!(:other_provider) { create(:provider) }
  given!(:permitted) { create(:permitted_attribute, provider: provider) }
  given(:object) { attribute.subject }
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

    click_link('Provided Attributes')
    expect(current_path).to eq("#{base_path}/provided_attributes")
  end

  scenario 'listing the provided attributes' do
    within('#provided-attributes tr', text: object.name) do
      expect(page).to have_content(object.mail)
      expect(page).to have_content(attribute.name)
      expect(page).to have_content(attribute.value)
    end
  end

  scenario 'listing attributes provided by a different provider' do
    visit '/providers'
    within('tr', text: other_provider.name) do
      click_link('View')
    end

    click_link('Provided Attributes')

    expect(page).to have_no_css('#provided-attributes tr',
                                text: attribute.value)
  end

  scenario 'providing a new attribute' do
    within('#available-subjects tr', text: object.name) do
      click_link('Provide Attribute')
    end

    expect(current_path).to eq("#{base_path}/provided_attributes/new")
    expect(page).to have_css('table.definition td', text: object.name)
    expect(page).to have_css('table.definition td', text: object.mail)

    value = permitted.available_attribute.value

    within('tr', text: value) do
      click_button('Add')
    end

    expect(current_path).to eq("#{base_path}/provided_attributes")
    expect(page).to have_css('#provided-attributes tr', text: value)
  end

  scenario 'revoking an attribute' do
    value = attribute.value

    expect(page).to have_css('#provided-attributes tr', text: value, count: 1)
    within('#provided-attributes tr', text: value) do
      click_delete_button
    end

    expect(page).to have_no_css('#provided-attributes tr', text: value)
  end
end
