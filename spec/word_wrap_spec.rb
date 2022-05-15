require_relative '../lib/word_wrap'

RSpec.describe WordWrap do
  subject { described_class.wrap(string, column) }

  describe '.wrap' do
    it 'takes in column number > 0' do
      expect { described_class.wrap('a', 0) }.to raise_error(ArgumentError)
    end

    it 'wraps a single word when the word is longer than column' do
      expect(described_class.wrap('a', 1)).to eq('a')
      expect(described_class.wrap('ab', 1)).to eq("a\nb")
      expect(described_class.wrap('abc', 1)).to eq("a\nb\nc")
    end

    it 'returns a single word when the word is exactly the column length' do
      expect(described_class.wrap('foo', 3)).to eq('foo')
    end

    it 'returns a single word when the word is shorter than column' do
      expect(described_class.wrap('foo', 4)).to eq('foo')
    end

    it 'returns a wrapped text when there are 2 words' do
      expect(described_class.wrap('foo bar', 3)).to eq("foo\nbar")
    end

    it 'returns a wrapped text when there are 3 words' do
      expect(described_class.wrap('foo bar baz', 8)).to eq("foo bar\nbaz")
    end

    xit 'returns a wrapped text when there are multiple words' do
      expect(described_class.wrap('foo boo bar baz', 8)).to eq("foo bar\nbar baz")
    end
  end
end
