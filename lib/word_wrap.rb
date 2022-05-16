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
    until @scanner.eos?
      @scanner.scan(WORD_PATTERN)

      word = @scanner.captures&.first

      if word.length <= @max_length
        yield word
      else
        segments(word) do |segment|
          yield segment
        end
      end
    end
  end

  def segments(word)
    until word.empty?
      yield word.slice!(0...@max_length)
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
    if current_line_has_space?(word)
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

  def new_line
    @lines ||= []
    @lines << Line.new(@column)
  end
end
