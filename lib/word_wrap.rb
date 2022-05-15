class WordWrap
  SPACE = ' '
  BLANK = ''

  def self.wrap(string, column)
    raise ArgumentError if column < 1

    return string if string.length <= column

    separator = string.include?(SPACE) ? SPACE : BLANK

    words = string.split(separator)

    result = words.each_with_object(StringIO.new) do |word, result|
      if new_length(result.length, word.length) <= column
        result.write(separator)
        result.write(word)
      else
        result.write("\n")
        result.write(word)
      end
    end

    result.string.strip
  end

  def self.new_length(current_length, word_length)
    current_length + word_length + 1
  end
end
