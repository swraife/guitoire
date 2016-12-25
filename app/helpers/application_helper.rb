module ApplicationHelper
  def file_icon_class(filetype)
    case filetype
    when 'application/pdf'
      return 'fa-file-pdf-o'
    when 'image/jpeg', 'image/gif', 'image/png'
      return 'fa-file-image-o'
    else
      return "fa-file-o"
    end
  end
end
