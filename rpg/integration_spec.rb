require_relative './game'

RSpec.describe 'RPG Integration Specs' do
  let!(:game) { RPG::Game.new }
  let!(:jedis) { game.create_faction(name: 'Jedis') }
  let!(:siths) { game.create_faction(name: 'Siths') }
  let!(:obi_wan) { game.create_character(level: 60) }
  let!(:anakin) { game.create_character(level: 59) }

  describe 'character attacking another similar level character' do
    it 'reduces the health of the other character until it dies' do
      obi_wan.deal_damage(anakin, 50)
      expect(anakin.health).to eq(950)

      anakin.deal_damage(obi_wan, 200)
      expect(obi_wan.health).to eq(800)

      obi_wan.deal_damage(anakin, 1000)
      expect(anakin).not_to be_alive
    end
  end
end
