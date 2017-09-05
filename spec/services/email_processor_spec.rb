require 'rails_helper'

describe EmailProcessor do
  let(:subject) { described_class.new(griddler_email) }
  let(:griddler_email) { build(:griddler_email, to: to) }
  let(:to) { [{ full: 'new@performr.world', email: 'new@performr.world', token: 'new', host: 'performr.world', name: nil }] }
  let(:performer) do
    create(:performer, user: create(:user, email: griddler_email.from[:email]))
  end

  describe '#process' do
    it 'creates a received_email' do
      expect do
        subject.process
      end.to change(ReceivedEmail, :count).by(1)
    end

    it 'creates a feat for the performer' do
      performer
      expect do
        subject.process
      end.to change(Feat, :count).by(1)
    end

    context 'when the sender is not known' do
      context 'when there are email attachments' do
        let(:griddler_email) { build(:griddler_email, :with_attachment, to: to) }

        it 'does not create resources for the attachments' do
          subject.process
          expect(FileResource.count).to eq(0)
          expect(Feat.count).to eq(0)
        end
      end
    end

    context 'when the subject name matches an existing feat name' do
      context 'when there are email attachments' do
        let(:griddler_email) { build(:griddler_email, :with_attachment, to: to) }

        it 'add resources to the sender\'s feat_role for the matching feat' do
          feat = create(:feat, owner: performer, name: griddler_email.subject)
          subject.process

          expect(Feat.count).to eq(1)
          expect(feat.feat_roles.first.resources.count).to eq(1)
        end
      end

      context 'when there are no email attachments' do
        it 'creates a \'pending\' feat' do
          feat = create(:feat, owner: performer, name: griddler_email.subject)
          subject.process

          expect(Feat.count).to eq(2)
        end
      end
    end

    context 'when the subject name matches multiple existing feats' do
      context 'when there are email attachments' do
        let(:griddler_email) { build(:griddler_email, :with_attachment, to: to) }

        it 'creates a pending resource' do
          2.times { create(:feat, owner: performer, name: griddler_email.subject) }
          subject.process

          expect(Resource.pending.count).to eq(1)
        end
      end

      context 'when there are no email attachments' do
        it 'creates a pending feat' do
          2.times { create(:feat, owner: performer, name: griddler_email.subject) }
          subject.process

          expect(Feat.pending.count).to eq(1)          
        end
      end
    end

    context 'when the subject name does not match any existing feats' do
      context 'when there are email attachments' do
        let(:griddler_email) { build(:griddler_email, :with_attachment, to: to) }

        it 'creates a published feat and resource' do
          performer
          subject.process

          expect(Resource.published.count).to eq(1)
          expect(Feat.published.count).to eq(1)
        end
      end

      context 'when there are no email attachments' do
        it 'creates a published feat' do
          performer
          subject.process

          expect(Feat.published.count).to eq(1)
        end
      end
    end
  end
end
