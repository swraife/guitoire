module Query::VisibilityQueryHelpers
  def visibility_everyone?(table)
    table[:visibility].eq('everyone')
  end

  def visibility_friends?(table)
    table[:visibility].eq('friends')
  end

  def visibility_only_admins?(table)
    table[:visibility].eq('only_admins')
  end

  def owner_is_friend?(table)
    table[:owner_id].in(friends_ids)
                    .and(table[:owner_type].eq('Performer'))
  end

  # including class must implement admin_#{var}_ids methods for all cases
  def is_admin?(table)
    visibility_only_admins?(table).and(table[:id].in(send("admin_#{table.name}_ids")))
  end

  def friends_ids
    raise "Including class must implement ##{__method__}!"
  end
end
