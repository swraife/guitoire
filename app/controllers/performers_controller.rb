class PerformersController < ApplicationController
  load_and_authorize_resource except: [:new, :create]
  skip_before_action :create_first_performer, only: [:new, :create]

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      user_filter = { user_id: @user.id }
    end

    @performers = Performer.visible_to(current_performer).where(user_filter)
                    .order(:public_name)
  end

  def show
    @friends = @performer.accepted_friends
    @friendship = current_performer.friendship_with(@performer)
  end

  def new
    @performer = Performer.new
    @layout = 'full'
  end

  def create
    @performer = Performer.create(performer_params.merge(user: current_user))
    redirect_to @performer
  end

  def edit
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
      :area_id, skill_ids: [], user_input_skill_list: []
    )
  end
end