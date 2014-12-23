require 'rails_helper'

require 'gumboot/shared_examples/subjects'

RSpec.describe Subject, type: :model do
  include_examples 'Subjects'
  it_behaves_like 'an audited model'

  context 'validations' do
    subject { build(:subject, complete: false) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:mail) }
    it { is_expected.not_to validate_presence_of(:targeted_id) }
    it { is_expected.not_to validate_presence_of(:shared_token) }

    context 'with a complete subject' do
      subject { build(:subject, complete: true) }

      it { is_expected.to validate_presence_of(:targeted_id) }
      it { is_expected.to validate_presence_of(:shared_token) }
    end
  end

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

  context '#functioning?' do
    context 'when enabled' do
      subject { create(:subject, enabled: true) }
      it { is_expected.to be_functioning }
    end

    context 'when disabled' do
      subject { create(:subject, enabled: false) }
      it { is_expected.not_to be_functioning }
    end
  end

  context '#accept' do
    let(:attrs) do
      attributes_for(:subject).slice(:name, :mail, :targeted_id, :shared_token)
    end

    let(:invitation) { create(:invitation, subject: subject) }

    def run
      subject.accept(invitation, attrs)
    end

    it 'updates the attributes' do
      run
      expect(subject.reload).to have_attributes(attrs)
    end

    it 'marks the invitation as used' do
      expect { run }.to change { invitation.reload.used? }.to be_truthy
    end

    it 'marks the subject as complete' do
      expect { run }.to change { subject.reload.complete? }.to be_truthy
    end
  end

  context '#providers' do
    let!(:provider) do
      create(:provider).tap do |provider|
        subject.roles.first.update_attributes!(provider: provider)
      end
    end
    let!(:other) { create(:provider) }
  end

  context 'associated objects' do
    context 'subject_role_assignments' do
      let(:child) { create(:subject_role_assignment) }
      subject { child.subject }
      it_behaves_like 'an association which cascades delete'
    end

    context 'provided_attributes' do
      let!(:child) { create(:provided_attribute) }
      subject { child.subject }
      it_behaves_like 'an association which cascades delete'
    end
  end
end
