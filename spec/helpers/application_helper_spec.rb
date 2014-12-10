require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context '#if_permitted' do
    def run(&bl)
      helper.if_permitted('some:action', &bl)
    end

    context 'with nil subject' do
      before { assign(:subject, nil) }

      it 'does not yield' do
        expect { |b| run(&b) }.not_to yield_control
      end
    end

    context 'when permitted' do
      before { assign(:subject, double(permits?: true)) }

      it 'yields' do
        expect { |b| run(&b) }.to yield_control
      end
    end

    context 'when denied' do
      before { assign(:subject, double(permits?: false)) }

      it 'does not yield' do
        expect { |b| run(&b) }.not_to yield_control
      end
    end
  end

  # TODO: Replace this with actual required behaviour.
  context '#environment_string' do
    subject { helper.environment_string }
    it { is_expected.to eq('Development') }
  end
end
