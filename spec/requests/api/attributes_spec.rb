require 'rails_helper'

module API
  RSpec.describe AttributesController, type: :request do
    let(:json) { JSON.parse(response.body) }
    let!(:object) { create(:subject, :authorized) }
  end
end
