require 'rails_helper'

RSpec.describe Provider, type: :model do
  it_behaves_like 'an audited model'

  context 'validations' do
    subject { build(:provider) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:identifier) }

    %W(aaf abcd1234_- #{'x' * 40}).each do |identifier|
      it { is_expected.to allow_value(identifier).for(:identifier) }
    end

    %W(aaf! abcd:1234 abc\ndef #{'x' * 41}).each do |identifier|
      it { is_expected.not_to allow_value(identifier).for(:identifier) }
    end
  end

  context '#invite' do
    let(:user) { create(:subject) }
    let(:provider) { create(:provider) }

    def run
      provider.invite(user)
    end

    it 'creates the invitation' do
      expect { run }.to change(Invitation, :count).by(1)
    end

    it 'sets the user attributes' do
      run
      expect(user.invitations.last)
        .to have_attributes(name: user.name, mail: user.mail,
                            subject_id: user.id)
    end

    it 'sets the expiry' do
      Timecop.freeze do
        run
        expect(user.invitations.last.expires.to_i).to eq(1.month.from_now.to_i)
      end
    end

    it 'returns the invitation' do
      expect(run).to be_an(Invitation)
    end
  end
end
