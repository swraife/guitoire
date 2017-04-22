ActsAsTaggableOn::Tag.class_eval do
  def translate_name
    I18n.t("skill_Fnames.#{name}", default: name)
  end
end