class FeatsController < ApplicationController
  load_and_authorize_resource except: [:new, :index]

  def index
    @performer = Performer.find(params[:performer_id])
    order = FeatRole.scopes.include?(params[:sort_by]&.to_sym) ? params[:sort_by] : 'order_by_name'

    @feat_roles = Query::FeatRoleQueryService.new(
      actor: @performer, viewer: current_performer, order: order
    ).find_feat_roles

    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def show
    @feat = Feat.includes(resources: [:resourceable]).find(params[:id])
    @current_performer_feat_role =
      @feat.feat_roles.where(owner: current_performer).first_or_initialize
    @groups_feat_roles = @feat.feat_roles.includes(:base_tags, :owner)
                           .where(owner: current_performer.groups)
  end

  def new
    @feat = current_performer.feats_as_owner.build
    @feats = current_performer.feats.order(:name)
    @feat_role = @feat.feat_roles.build
  end

  def create
    @feat = Feat.new(feat_params.merge(creator: current_performer))
    params[:custom_contexts]&.each do |k,v|
      @feat.set_tag_list_on(helpers.context_name_for(k), v)
    end

    if @feat.save
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
    @feat_role = @feat.feat_roles.where(owner: current_performer).first_or_initialize
  end

  def update
    @feat.assign_attributes(feat_params.except(:admin_performer_ids, :admin_group_ids))
    params[:custom_contexts]&.each do |k,v|
      @feat.set_tag_list_on(helpers.context_name_for(k), v)
    end

    if @feat_role = @feat.feat_roles.where(owner: @feat.owner).first_or_initialize
                      .update(feat_role_params)
    # Have to use feat_role_updater instead of ActiveRecord methods, because performer
    # may have an existing non-admin feat_role for the feat
      if @feat.save
        FeatRoleUpdater.new(@feat, feat_params[:admin_performer_ids],
                            feat_params[:admin_group_ids]).update!
        redirect_to performer_feat_path(current_performer, @feat)
      end
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

  def feat_role_params
    params.require(:feat_role).permit(private_list: [])
  end
end
