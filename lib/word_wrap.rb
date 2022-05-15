class WordWrap
  SPACE = ' '
  BLANK = ''

  def self.wrap(string, column)
    raise ArgumentError if column < 1

    parser = Parser.new(string)
    collector = Collector.new(column)

    parser.each_word do |word|
      collector.add_word(word)
    end

    collector.result
  end
end

class Parser
  WORD_PATTERN = %r{([A-z]+)[ \n]?}

  def initialize(string)
    @scanner = StringScanner.new(string)
  end

  def each_word
    until @scanner.eos?
      @scanner.scan(WORD_PATTERN)

      yield @scanner.captures&.first
    end
  end
end

class Collector
  SPACE = ' '

  def initialize(column)
    @buffer = StringIO.new
    @column = column
    @current_line_length = 0
  end

  def add_word(word)
    if current_line_has_space?(word)
      add_to_current_line(word)
    else
      add_on_new_line(word)
    end
  end

  def result
    @buffer.string.strip
  end

  private

  def current_line_has_space?(word)
    @current_line_length + word.length <= @column
  end

  def add_to_current_line(word)
    @buffer.write(word)
    @buffer.write(SPACE)

    @current_line_length += word.length + 1
  end

  def add_on_new_line(word)
    if too_long_for_column?(word)
      return add_word_segments(word)
    end

    new_line
    add_word(word)
  end

  def new_line
    @buffer.ungetc(SPACE)
    @buffer.write("\n")

    @current_line_length = 0
  end

  def add_word_segments(word)
    until word.empty?
      segment = word.slice!(0...@column)
      add_on_new_line(segment)
    end
  end

  def too_long_for_column?(word)
    word.length > @column
  end
end
