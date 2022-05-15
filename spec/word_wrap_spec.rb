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
  end
end
