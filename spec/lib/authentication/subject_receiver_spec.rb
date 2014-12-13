require 'rails_helper'

module Authentication
  RSpec.describe SubjectReceiver do
    let(:env) { {} }

    context '#map_attributes' do
      let(:attrs) do
        keys = %w(edupersontargetedid auedupersonsharedtoken displayname mail)
        keys.reduce({}) { |a, e| a.merge(e => e) }
      end

      it 'maps the attributes' do
        expect(subject.map_attributes(env, attrs))
          .to eq(name: 'displayname',
                 mail: 'mail',
                 shared_token: 'auedupersonsharedtoken',
                 targeted_id: 'edupersontargetedid')
      end
    end

    context '#subject' do
      let(:attrs) do
        attributes_for(:subject)
      end

      it 'creates the subject' do
        expect { subject.subject(env, attrs) }.to change(Subject, :count).by(1)
      end

      it 'returns the new subject' do
        obj = subject.subject(env, attrs)
        expect(obj).to be_a(Subject)
        expect(obj).to have_attributes(attrs.except(:audit_comment))
      end

      it 'updates an existing subject' do
        obj = subject.subject(env, attrs.merge(name: 'Wrong',
                                               mail: 'wrong@example.com'))
        subject.subject(env, attrs)
        expect(obj.reload).to have_attributes(attrs.except(:audit_comment))
      end

      it 'returns the existing subject' do
        obj = subject.subject(env, attrs)
        expect(subject.subject(env, attrs)).to eq(obj)
      end

      it 'records an audit record on creation' do
        expect { subject.subject(env, attrs) }
          .to change(Audited.audit_class, :count).by(1)
      end

      it 'records an audit record on update' do
        obj = subject.subject(env, attrs.merge(name: 'Wrong',
                                               mail: 'wrong@example.com'))
        expect { subject.subject(env, attrs) }
          .to change(Audited.audit_class, :count).by(1)
      end

      it 'does not record an audit record when nothing changes' do
        subject.subject(env, attrs)
        expect { subject.subject(env, attrs) }
          .not_to change(Audited.audit_class, :count)
      end

      context 'with an invite code' do
        let!(:invitation) { create(:invitation) }
        let(:attrs) { attributes_for(:subject) }
        let(:env) { { 'rack.session' => { invite: invitation.identifier } } }

        it 'does not create a subject' do
          expect { subject.subject(env, attrs) }.not_to change(Subject, :count)
        end

        it 'returns the existing subject' do
          expect(subject.subject(env, attrs)).to eq(invitation.subject)
        end

        it 'updates the attributes' do
          expected = attrs.except(:invite, :complete, :audit_comment)
          expect(subject.subject(env, attrs)).to have_attributes(expected)
        end

        it 'completes the subject' do
          expect { subject.subject(env, attrs) }
            .to change { invitation.subject.reload.complete? }.to true
        end

        it 'marks the invite as used' do
          expect { subject.subject(env, attrs) }
            .to change { invitation.reload.used? }.to true
        end

        context 'when the invitation fails to save' do
          before do
            allow_any_instance_of(Invitation).to receive(:update_attributes!)
              .and_raise('an failure')
          end

          it 'preserves the subject' do
            expect { subject.subject(env, attrs) }
              .to raise_error(/an failure/)
              .and not_change { invitation.subject.reload.attributes }
          end
        end

        context 'when the subject fails to save' do
          before do
            allow_any_instance_of(Subject).to receive(:update_attributes!)
              .and_raise('an failure')
          end

          it 'preserves the invite' do
            expect { subject.subject(env, attrs) }
              .to raise_error(/an failure/)
              .and not_change { invitation.reload.attributes }
          end
        end
      end
    end
  end
end
