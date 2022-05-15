class WordWrap
  def self.wrap(string, column)
    raise ArgumentError if column < 1

    if string.length <= column
      return string
    end

    if string.include?(' ')
      return string.split(" ").join("\n")
    end

    string.split("").join("\n")
  end
end
