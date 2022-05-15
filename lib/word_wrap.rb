class WordWrap
  def self.wrap(string, column)
    raise ArgumentError if column < 1

    if string.length <= column
      return string
    end

    if string.include?(' ')
      words = string.split(' ')

      result = words.each_with_object(StringIO.new) do |word, result|
        if new_length(result.length, word.length) <= column
          result.write(' ')
          result.write(word)
        else
          result.write("\n")
          result.write(word)
        end
      end

      return result.string.strip
    end

    string.split("").join("\n")
  end

  def self.new_length(current_length, word_length)
    current_length + word_length + 1
  end
end
