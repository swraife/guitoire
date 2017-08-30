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

    context 'when email is sent to \'new@\'' do
      it 'creates a feat for the performer' do
        performer
        expect do
          subject.process
        end.to change(Feat, :count).by(1)
      end

      context 'when there are email attachments' do
        let(:griddler_email) { build(:griddler_email, :with_attachment, to: to) }

        it 'creates resources for the attachments' do
          performer
          expect do
            subject.process
          end.to change(FileResource, :count).by(1)
        end
      end
    end
  end
end
