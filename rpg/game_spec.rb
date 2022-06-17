require_relative './game'

RSpec.describe RPG::Game do
  let(:game) { described_class.new }

  describe '#create_character' do
    subject(:character) { game.create_character }

    it 'returns a level 1 character' do
      expect(character).to be_a(RPG::Character)
      expect(character.level).to eq(1)
    end

    it 'adds character to the game' do
      expect(game.characters).to contain_exactly(character)
    end

    describe 'with a level' do
      let(:level) { 100 }

      it 'creates character at the given level' do
        character = game.create_character(level: level)

        expect(character.level).to eq(level)
      end
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

    describe '#create_item' do
      let(:health) { 100 }

      subject(:item) { game.create_item(health: health) }

      it 'adds item to the game' do
        expect(game.items).to contain_exactly(item)
      end
    end
  end
end
