require_relative './game'

RSpec.describe 'RPG Integration Specs' do
  let!(:game) { RPG::Game.new }
  let!(:jedis) { game.create_faction(name: 'Jedis') }
  let!(:siths) { game.create_faction(name: 'Siths') }
  let!(:obi_wan) { game.create_character(level: 60) }
  let!(:anakin) { game.create_character(level: 59) }
  let!(:youngling) { game.create_character(level: 10) }
  let!(:bactasuit) { game.create_item(health: 800) }

  describe 'an RPG story' do
    context 'with alliances' do
      before do
        obi_wan.join(jedis)
        youngling.join(jedis)

        anakin.join(siths)
      end

      it 'tells of enemies fighting and dying' do
        obi_wan.deal_damage(anakin, 50)
        anakin.deal_damage(obi_wan, 200)
        obi_wan.heal(anakin, 100)
        obi_wan.deal_damage(anakin, 1000)

        obi_wan.heal(obi_wan, 100)

        expect(obi_wan.health).to eq(900)
        expect(anakin).not_to be_alive
      end

      it 'tells of a helpless fight between the weak and the villain' do
        anakin.deal_damage(youngling, 400)
        youngling.deal_damage(anakin, 10)
        anakin.deal_damage(youngling, 400)

        obi_wan.heal(youngling, 100)

        expect(anakin.health).to eq(995)
        expect(youngling).not_to be_alive
      end
    end
  end
end
