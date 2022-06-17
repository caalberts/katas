require_relative './game'

RSpec.describe RPG::Game do
  let(:game) { described_class.new }

  describe '#create_character' do
    subject(:character) { game.create_character }

    it 'returns a character' do
      expect(character).to be_a(RPG::Character)
    end

    it 'adds character to the game' do
      expect(game.characters).to contain_exactly(character)
    end
  end
end
