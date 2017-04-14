class FeatsController < ApplicationController
  load_and_authorize_resource except: :new

  def index
    @performer = Performer.find(params[:performer_id])
    order = FeatRole.scopes.include?(params[:sort_by]&.to_sym) ? params[:sort_by] : 'order_by_feat_name'
    @feat_roles = @performer.subscriber_feat_roles.includes(:plays, feat: :tags).send(order)

    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def show
    @feat = Feat.includes(resources: [:resourceable]).find(params[:id])
    @current_performer_feat_role = @feat.feat_roles.where(owner: current_performer)
                                              .first_or_initialize
  end

  def new
    @feat = Feat.new
    @feats = current_performer.feats.order(:name)
  end

  def create
    if @feat = Feat.create(feat_params.merge(creator: current_performer))
      redirect_to @feat
    end
  end

  def copy
    if @new_feat = FeatCopier.new(copy_creator: current_performer, feat: @feat).copy!
      redirect_to feat_path(@new_feat),
        flash: { notice: "Copy of #{@new_feat.name} created!" }
    end
  end

  def destroy
    if @feat.destroy
      redirect_to performer_feats_path(current_performer),
        flash: { notice: "#{@feat.name} was deleted!"}
    end
  end

  def edit
    @feats = Feat.includes(:subscriber_feat_roles)
                 .where(feat_roles: { owner: current_performer.actors })
                 .order(:name)
  end

  def update
    # Have to use feat_role_updater instead of ActiveRecord methods, because performer
    # may have an existing non-admin feat_role for the feat
    if @feat.update(feat_params.except(:admin_performer_ids, :admin_group_ids))
      FeatRoleUpdater.new(@feat, feat_params[:admin_performer_ids],
                          feat_params[:admin_group_ids]).update!
      redirect_to performer_feat_path(current_performer, @feat)
    end
  end

  private

  def feat_params
    params.require(:feat).permit(
      :name, :description, :tempo, :music_key, :composer_id, :scale,
      :time_signature, :global_owner, :visibility, version_list: [], 
      genre_list: [], generic_list: [], composer_list: [], admin_performer_ids: [],
      admin_group_ids: []
    )
  end
end
