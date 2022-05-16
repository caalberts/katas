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

  class Line
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
      @buffer.size + word.length <= @column
    end

    def to_s
      @buffer.string
    end
  end

  def initialize(column)
    @column = column
    @lines = []
  end

  def add_word(word)
    if too_long_for_column?(word)
      add_word_segments(word)
    elsif current_line_has_space?(word)
      add_to_current_line(word)
    else
      add_on_new_line(word)
    end
  end

  def result
    @lines.map(&:to_s).join("\n")
  end

  private

  def current_line
    @lines.last
  end

  def current_line_has_space?(word)
    current_line&.has_space?(word)
  end

  def add_to_current_line(word)
    current_line.append(word)
  end

  def add_on_new_line(word)
    new_line
    add_to_current_line(word)
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

  def new_line
    @lines ||= []
    @lines << Line.new(@column)
  end
end
