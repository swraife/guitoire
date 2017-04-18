module Contexts
  def self.name_for(context)
    context.downcase.gsub(' ', '_')
  end

  def self.names_for(context_setting)
    context_setting.map { |context| context_name_for context }
  end
end