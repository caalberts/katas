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

    it 'returns a wrapped text when there are multiple words' do
      expect(described_class.wrap('foo boo bar baz', 8)).to eq("foo boo\nbar baz")
    end

    it 'returns a wrapped text when first line has longer word' do
      expect(described_class.wrap('fooboobar baz duh', 9)).to eq("fooboobar\nbaz duh")
    end

    it 'returns a wrapped text when next line has longer word' do
      expect(described_class.wrap('foo boo barbazduh', 9)).to eq("foo boo\nbarbazduh")
    end

    it 'returns a wrapped text when there are different length words' do
      expect(described_class.wrap('foo barbazduh bart f', 6)).to eq("foo\nbarbaz\nduh\nbart f")
    end
  end
end

RSpec.describe Parser do
  subject { described_class.new(string) }

  describe '#each_word' do
    let(:string) { 'foo bar baz' }

    it 'yields each word in the string' do
      expect { |b| subject.each_word(&b) }.to yield_successive_args('foo', 'bar', 'baz')
    end
  end
end
