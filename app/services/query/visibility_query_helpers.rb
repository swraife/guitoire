module Query::VisibilityQueryHelpers
  def visibility_everyone?(table)
    table[:visibility].eq('everyone')
  end

  def visibility_only_admins?(table)
    table[:visibility].eq('only_admins')
  end

  # including class must implement admin_#{var}_ids methods for all cases
  def is_admin?(table)
    visibility_only_admins?(table).and(table[:id].in(send("admin_#{table.name}_ids")))
  end
end
