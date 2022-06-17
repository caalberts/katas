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

  describe '#create_faction' do
    let(:faction_name) { 'Jedi' }

    subject(:faction) { game.create_faction(name: faction_name) }

    it 'returns a faction with the name' do
      expect(faction.name).to eq(faction_name)
    end

    it 'adds faction to the game' do
      expect(game.factions).to contain_exactly(faction)
    end
  end
end
