class WordWrap
  def self.wrap(string, column)
    raise ArgumentError if column < 1

    string.split("").join("\n")
  end
end
