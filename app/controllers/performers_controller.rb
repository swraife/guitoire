class PerformersController < ApplicationController
  load_and_authorize_resource except: [:new, :create]
  skip_before_action :create_first_performer, only: [:new, :create]
  before_action :format_params, only: [:create, :update]

  def index
    @performers = current_performer.followed.order(:public_name)
  end

  def show
    @followed = @performer.followed
    @follow = current_performer.follows_as_follower
                               .where(performer: @performer)
                               .first_or_initialize
    @feats = @performer.subscriber_feats.order(created_at: :desc)
    @routines = @performer.routines.order(created_at: :desc)
  end

  def new
    @usernames = Performer.pluck(:username)
    @performer = Performer.new
    @layout = 'full'
  end

  def create
    @performer = Performer.create(performer_params.merge(user: current_user))
    redirect_to @performer
  end

  def edit
    @usernames = Performer.where.not(id: @performer.id).pluck(:username)
  end

  def update
    if current_performer.update(performer_params)
      redirect_to current_performer
    end
  end

  def destroy
  end

  private

  def performer_params
    params.require(:performer).permit(
      :name, :public_name, :avatar, :description, :email, :visibility,
      :username, :area_id, :feat_name, :routine_name, standard_skill_ids: [],
      user_input_skill_list: [], feat_contexts: []
    )
  end

  def format_params
    params[:performer][:feat_name] = params[:performer][:feat_name].reject(&:blank?).first
    params[:performer][:routine_name] = params[:performer][:routine_name].reject(&:blank?).first
  end
end
