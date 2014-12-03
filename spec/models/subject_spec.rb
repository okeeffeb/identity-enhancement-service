require 'rails_helper'

RSpec.describe Subject do
  subject { create(:subject) }
  let(:role) do
    create(:role).tap do |role|
      create(:permission, value: 'a:*', role: role)
    end
  end

  context '#permits?' do
    it 'derives permissions from roles' do
      subject.subject_role_assignments.create(role_id: role.id)
      expect(subject.permits?('a:b:c')).to be_truthy
    end

    it 'only applies permissions from assigned roles' do
      role
      expect(subject.permits?('a:b:c')).to be_falsey
    end
  end
end
