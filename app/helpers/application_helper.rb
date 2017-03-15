module ApplicationHelper
  def truncated_sentence_array(arr, options = {})
    options.assert_valid_keys(:words_connector, :two_words_connector, :last_word_connector, :locale, :truncate_length)

    default_connectors = {
      :words_connector     => ', ',
      :two_words_connector => ' and ',
      :last_word_connector => ', and ',
      :more_word_connector => ->(n) { ", and #{n} more" },
      :truncate_length     => 3
    }
    if defined?(I18n)
      i18n_connectors = I18n.translate(:'support.array', locale: options[:locale], default: {})
      default_connectors.merge!(i18n_connectors)
    end
    options = default_connectors.merge!(options)

    arr_length = arr.length
    case
    when arr_length == 0
      []
    when arr_length == 1
      arr
    when arr_length == 2
      [arr[0], options[:two_words_connector], arr[1]]
    when arr_length > options[:truncate_length]
      arr.first(options[:truncate_length]).each_with_object([]).with_index do |(item, new_arr), index|
        new_arr.push(options[:words_connector]) unless [0, arr_length - 1].include?(index)
        new_arr.push(item)
        new_arr.push(options[:more_word_connector].call(arr_length - options[:truncate_length])) if index == options[:truncate_length] - 1
      end
    else
      arr.each_with_object([]).with_index do |(item, new_arr), index|
        new_arr.push(options[:words_connector]) unless [0, arr_length - 1].include?(index)
        new_arr.push(options[:last_word_connector]) if index == arr_length - 1
        new_arr.push(item)
      end
    end
  end

  def user_has_groups(user)
    user.actors.length > 1
  end
end
