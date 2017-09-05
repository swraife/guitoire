require 'fuzzystringmatch'

class NameMatcher
  attr_reader :string, :collection, :attribute, :certainty

  CERTAINTY_LEVELS = { low: 0.9, high: 0.95 }
  STARTING_WORDS = %w(a an the i he she you we they it i'll i'm)

  def initialize(string, collection, attribute=:name, certainty=:low)
    @string = string.downcase
    @collection = collection
    @attribute = attribute
    @certainty = CERTAINTY_LEVELS[certainty]
  end

  def find_matches
    collection.each_with_object([]) do |item, results|
      item_str = item.send(attribute).to_s.downcase
      dist = distance(item_str, string)
      if dist > certainty
        results.push({ match: item, distance: dist })
        next
      end

      if word = omitted_starting_word(item_str, string)
        # horrible naming. 'item_str' uses the same name, but 'string' uses new, b/c 'string' value must persist.
        item_str = item_str.start_with?(word) ? item_str.sub(word, "") : item_str
        str2 = string.start_with?(word) ? string.sub(word, '') : string
        dist = distance(item_str, str2)
        results.push({ match: item, distance: dist }) if dist > certainty
      end
    end
  end

  # checks to see if the beginning of two string args differ by the absence or
  # inclusion of one of STARTING_WORDS. If yes, it returns that word. If no,
  # nil is returned.
  def omitted_starting_word(str1, str2)
    STARTING_WORDS.each do |word|
      word += ' '
      return word if str1.start_with?(word) ^ str2.start_with?(word)
    end
    nil
  end

  # Returns the 'distance' between two strings as a float between 0 and 1.0
  def distance(str1, str2)
    jarow.getDistance(str1, str2)
  end

  def jarow
    @jarow ||= FuzzyStringMatch::JaroWinkler.create(:native)
  end
end
