require 'rails_helper'

RSpec.describe Query::FeatQueryService do
  let(:actor) { create(:performer) }
  let(:feat) { create(:feat, owner: owner, visibility: visibility) }
  let(:owner) { actor }
  let(:viewer) { actor }
  let(:visibility) { 'everyone' }
  let(:feat_role) { feat.feat_roles.first }
  let(:tag) { create(:tag) }

  describe '#find_feats' do
    let(:subject) do
      described_class.new(actor: actor, viewer: viewer).find_feats
    end

    context 'when viewer is the actor' do
      it 'returns the actor\'s find_feats' do
        expect(subject).to include(feat)
      end

      it 'returns the feat where feat visibility is friends' do
        feat.friends!
        expect(subject).to include(feat)
      end

      it 'returns the feat where feat visibility is only_admins' do
        feat.only_admins!
        expect(subject).to include(feat)
      end

      context 'when actor doesn\'t have a subscriber feat role for feat' do
        let(:owner) { create(:performer) }

        it 'does not return feat when actor has not feat role' do
          expect(subject).to be_empty
        end

        it 'does not return feat when actor feat.viewer? is true' do
          actor.viewer_feats << feat

          expect(subject).not_to include(actor.feats.first)
        end
      end

      context 'it orders feats correctly' do
        it 'returns find_feats ordered by feat name' do
          ('a'..'c').each do |name|
            create(:feat, owner: owner, visibility: visibility, name: name)
          end

          expect(subject.map { |i| i.name}).to eq(%w(a b c))
        end

        context 'order is last_played' do
          let(:subject) {
            described_class.new(actor: actor, viewer: viewer, order: 'order_by_last_played').find_feats
          }

          it 'returns feats by last played date' do
            ('a'..'c').each do |name|
              f = create(:feat, owner: owner, visibility: visibility, name: name)
              Play.create(feat_role: f.feat_roles.first) unless name == 'b'
            end
            
            expect(subject.map { |i| i.name}).to eq(%w(c a b))
          end
        end

        context 'order is created_at' do
          let(:subject) {
            described_class.new(actor: actor, viewer: viewer, order: 'order_by_created_at').find_feats
          }

          it 'returns feats by created_at date' do
            ('a'..'c').each do |name|
              create(:feat, owner: owner, visibility: visibility, name: name)
            end

            expect(subject.map(&:name)).to eq(%w(c b a))
          end
        end

        context 'order is plays_count' do
          let(:subject) {
            described_class.new(actor: actor, viewer: viewer, order: 'order_by_plays_count').find_feats
          }

          it 'returns feats by plays_count' do
            ('a'..'c').each_with_index do |name, i|
              f = create(:feat, owner: owner, visibility: visibility, name: name)
              i.times { Play.create(feat_role: f.feat_roles.first) }
              if name == 'a'
                other_performer = create(:performer)
                FeatRole.create(feat: f, role: 1, owner: other_performer, plays_count: 5)
              end
            end
            expect(subject.map { |i| i.name}).to eq(%w(c b a))
          end
        end
      end
    end

    context 'when viewer is not the actor' do
      let(:viewer) { create(:performer) }

      context 'feat visibility is everyone' do
        it 'returns the feat' do
          expect(subject).to include(feat)
        end
      end

      context 'when feat visibility is friends' do
        let(:visibility) { 'friends' }

        context 'when viewer and actor are not friends' do
          it 'does not return the feat' do
            expect(subject).not_to include(feat)
          end
        end

        context 'when viewer and actor are friends' do
          let!(:friendship) { Friendship.create(connector: actor, connected: viewer, status: 'accepted') }
          it 'returns the feat' do
            expect(subject).to include(feat)
          end
        end
      end

      context 'when feat visibility is only_admins?' do
        let(:visibility) { 'only_admins' }

        context 'viewer is a feat admin' do
          it 'returns the feat' do
            feat.admin_performers << viewer
            expect(subject).to include(feat)
          end
        end

        context 'viewer is not a feat admin' do
          it 'does not return the feat' do
            expect(subject).not_to include(feat)
          end
        end
      end
    end

    context 'when actor is nil' do
      let(:subject) do
        described_class.new(actor: nil, viewer: viewer).find_feats
      end

      it 'finds all viewable feats' do
        expect(subject).to include(feat)
      end
    end

    context 'when filter tags are provided' do
      let(:subject) do
        described_class.new(actor: actor, viewer: viewer, filters: filters).find_feats
      end

      context 'when tags are given' do
        let(:filters) { { tags: [tag] } }

        it 'finds feats with the tags' do
          feat.update(generic_list: "#{tag.name}, other_tag")
          feat2 = create(:feat, owner: owner, visibility: visibility, generic_list: 'other_tag')

          expect(subject).to include(feat)
          expect(subject).not_to include(feat2)
        end
      end

      context 'when name is given' do
        let(:filters) { { name: feat.name[1, 2] } }

        it 'finds feats matching the name' do
          feat2 = create(:feat, owner: owner, visibility: visibility, name: 'Nope')

          expect(subject).to include(feat)
          expect(subject).not_to include(feat2)
        end
      end
    end
  end
end
