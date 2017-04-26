# require 'rails_helper'

# RSpec.describe Query::FeatQueryService do
#   let(:actor) { create(:performer) }
#   let(:feat) { create(:feat, owner: owner, visibility: visibility) }
#   let(:owner) { actor }
#   let(:viewer) { actor }
#   let(:visibility) { 'everyone' }

#   describe '#find_feats' do
#     let(:subject) do
#       described_class.new(actor: actor, viewer: viewer).find_feats
#     end

#     context 'when viewer is the actor' do
#       it 'returns the actor\'s feats' do
#         expect(subject).to include(feat)
#       end

#       it 'returns feats where visibility is friends' do
#         feat.friends!
#         expect(subject).to include(feat)
#       end

#       it 'returns feats where visibility is only_admins' do
#         feat.only_admins!
#         expect(subject).to include(feat)
#       end

#       context 'when actor doesn\'t have a subscriber feat role for feat' do
#         let(:owner) { create(:performer) }

#         it 'does not return feat when actor has not feat role' do
#           expect(subject).not_to include(feat)
#         end

#         it 'does not return feat when actor feat_role.viewer? is true' do
#           actor.viewer_feats << feat

#           expect(subject).not_to include(feat)
#         end
#       end

#       context 'it orders feats correctly' do
#         it 'returns feats in alphabetical order' do
#           ('a'..'c').each do |name|
#             create(:feat, owner: owner, visibility: visibility, name: name)
#           end

#           expect(subject.pluck(:name)).to eq(%w(a b c))
#         end

#         context 'order is last_played' do
#           let(:subject) {
#             described_class.new(actor: actor, viewer: viewer, order: 'last_played').find_feats
#           }

#           it 'returns feats by last played date' do
#             ('a'..'c').each do |name|
#               f = create(:feat, owner: owner, visibility: visibility, name: name)
#               Play.create(feat_role: f.feat_roles.first) unless name == 'b'
#             end

#             expect(subject.pluck(:name)).to eq(%w(c a b))
#           end
#         end

#         context 'order is created_at' do
#           let(:subject) {
#             described_class.new(actor: actor, viewer: viewer, order: 'created_at').find_feats
#           }

#           it 'returns feats by last played date' do
#             ('a'..'c').each do |name|
#               create(:feat, owner: owner, visibility: visibility, name: name)
#             end

#             expect(subject.pluck(:name)).to eq(%w(c b a))
#           end
#         end

#         context 'order is plays_count' do
#           let(:subject) {
#             described_class.new(actor: actor, viewer: viewer, order: 'plays_count').find_feats
#           }

#           xit 'returns feats by last played date' do
#             ('a'..'c').each_with_index do |name, i|
#               f = create(:feat, owner: owner, visibility: visibility, name: name)
#               i.times { Play.create(feat_role: f.feat_roles.first) }
#               if name == 'a' 
#                 other_performer = create(:performer)
#                 fr = FeatRole.create(feat: f, role: 1, owner: other_performer, plays_count: 5)
#               end
#             end

#             expect(subject.pluck(:name)).to eq(%w(c b a))
#           end
#         end
#       end
#     end

#     context 'when viewer is not the actor' do
#       let(:viewer) { create(:performer) }

#       context 'feat visibility is everyone' do
#         it 'returns the feat' do
#           expect(subject).to include(feat)
#         end
#       end

#       context 'when feat visibility is friends' do
#         let(:visibility) { 'friends' }

#         context 'when viewer and actor are not friends' do
#           it 'does not return the feat' do
#             expect(subject).not_to include(feat)
#           end
#         end

#         context 'when viewer and actor are friends' do
#           let!(:friendship) { Friendship.create(connector: actor, connected: viewer, status: 'accepted') }
#           it 'returns the feat' do
#             expect(subject).to include(feat)
#           end
#         end
#       end

#       context 'when feat visibility is only_admins?' do
#         let(:visibility) { 'only_admins' }

#         context 'viewer is a feat admin' do
#           it 'returns the feat' do
#             feat.admin_performers << viewer
#             expect(subject).to include(feat)
#           end
#         end

#         context 'viewer is not a feat admin' do
#           it 'does not return the feat' do
#             expect(subject).not_to include(feat)
#           end
#         end
#       end
#     end
#   end
# end
