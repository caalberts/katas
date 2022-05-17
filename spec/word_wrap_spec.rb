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
  subject { described_class.new(string, max_length) }

  describe '#each_word' do
    let(:string) { 'foo bar baz' }
    let(:max_length) { 4 }

    it 'yields each word in the string' do
      expect { |b| subject.each_word(&b) }.to yield_successive_args('foo', 'bar', 'baz')
    end

    context 'when a word is longer than max length' do
      let(:string) { 'foo barbaz dot'}

      it 'splits long word at max length' do
        expect { |b| subject.each_word(&b) }.to yield_successive_args('foo', 'barb', 'az', 'dot')
      end
    end
  end
end

RSpec.describe Line do
  let(:column) { 8 }

  subject { described_class.new(column) }

  describe '#append' do
    context 'on empty line' do
      it 'appends the word' do
        subject.append('foo')

        expect(subject.to_s).to eq('foo')
      end
    end

    context 'on line with existing word' do
      it 'appends the word with a space separation' do
        subject.append('foo')
        subject.append('bar')

        expect(subject.to_s).to eq('foo bar')
      end
    end
  end

  describe '#has_space?' do
    context 'on empty line' do
      context 'when there is still space for new word' do
        it 'returns true' do
          expect(subject.has_space?('foobarba')).to be_truthy
        end
      end

      context 'when there is not enough space for new word' do
        it 'returns false' do
          expect(subject.has_space?('foobarbaz')).to be_falsey
        end
      end
    end

    context 'on line with existing word' do
      before do
        subject.append('foo')
      end

      context 'when there is still space for new word' do
        it 'returns true' do
          expect(subject.has_space?('bar')).to be_truthy
        end
      end

      context 'when there is not enough space for new word' do
        it 'returns false' do
          expect(subject.has_space?('barbaz')).to be_falsey
        end
      end

      context 'when there is not enough space for new word and the space' do
        it 'returns false' do
          expect(subject.has_space?('barba')).to be_falsey
        end
      end
    end
  end
end
