class ActivityService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def dashboard_activities
    public_activity
  end

  private

  def public_activity
    PublicActivity::Activity.includes(:trackable, :owner, recipient: :creator)
  end

  def activities
    @arel_table ||= PublicActivity::Activity.arel_table
  end

  def trackable_is_visible_to_everyone
    # activities
  end

  def friends_ids
    @friends_ids ||= user.friendships_user_ids
  end
end
