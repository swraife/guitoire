class ActivityGrouper
  attr_reader :activities

  def initialize(activities)
    @activities = activities
  end

  def grouped_activities
    @grouped_activities ||= activities.group_by do |activity|
      activity.group
    end
  end

  def each
    grouped_activities.each do |k,v|
      yield(v)
    end
  end
end
