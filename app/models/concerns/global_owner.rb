module GlobalOwner
  extend ActiveSupport::Concern

  def global_owner
    owner&.to_global_id
  end

  def global_owner=(owner)
    self.owner = GlobalID::Locator.locate owner
  end
end
