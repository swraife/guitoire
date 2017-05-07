class FeatRolesController < ApplicationController
  load_and_authorize_resource

  def create
    @feat = Feat.find(feat_role_params[:feat_id])
    if FeatRole.create(feat_role_params)
      redirect_back fallback_location: @feat, flash: { error: 'Uh oh, something broke!' }
    end
  end

  def update
    @feat = @feat_role.feat
    if @feat_role.update(feat_role_params)
      redirect_back(fallback_location: @feat)
    end
  end

  private

  def feat_role_params
    params.require(:feat_role).permit(:feat_id, :role, :global_owner, private_list: [])
  end
end