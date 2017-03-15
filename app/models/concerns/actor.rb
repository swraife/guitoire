module Actor
  extend ActiveSupport::Concern

  def global_id
    to_global_id.to_param
  end
end  