class WordWrap
  SPACE = ' '
  BLANK = ''

  def self.wrap(string, column)
    raise ArgumentError if column < 1

    parser = Parser.new(string, column)
    collector = Collector.new(column)

    parser.each_word do |word|
      collector.add_word(word)
    end

    collector.result
  end
end

class Parser
  WORD_PATTERN = %r{([A-z]+)[ \n]?}

  def initialize(string, max_length)
    @scanner = StringScanner.new(string)
    @max_length = max_length
  end

  def each_word
    until @scanner.eos? || !@scanner.scan(WORD_PATTERN)
      word = @scanner.captures&.first

      segmentize(word) do |segment|
        yield segment
      end
    end
  end

  private

  def segmentize(word)
    return yield word if word.length <= @max_length

    until word.empty?
      yield word.slice!(0...@max_length)
    end
  end
end

class Collector
  def initialize(column)
    @column = column
    @lines = []
  end

  def add_word(word)
    line_for(word).append(word)
  end

  def result
    @lines.map(&:to_s).join("\n")
  end

  private

  def line_for(word)
    if current_line&.has_space?(word)
      current_line
    else
      new_line
    end
  end

  def current_line
    @lines.last
  end

  def new_line
    Line.new(@column).tap do|line|
      @lines << line
    end
  end
end

class Line
  SPACE = ' '

  def initialize(column)
    @column = column
    @buffer = StringIO.new
  end

  def append(word)
    if @buffer.size > 0
      @buffer.write(SPACE)
    end

    @buffer.write(word)
  end

  def has_space?(word)
    required_space = @buffer.size == 0 ? word.length : SPACE.length + word.length

    @buffer.size + required_space <= @column
  end

  def to_s
    @buffer.string
  end
end
