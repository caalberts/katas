require_relative './game'

RSpec.describe 'RPG Integration Specs' do
  let!(:game) { RPG::Game.new }
  let!(:jedis) { game.create_faction(name: 'Jedis') }
  let!(:siths) { game.create_faction(name: 'Siths') }
  let!(:obi_wan) { game.create_character(level: 60) }
  let!(:anakin) { game.create_character(level: 59) }
  let!(:youngling) { game.create_character(level: 10) }

  describe 'character are in factions' do
    before do
      obi_wan.join(jedis)
      youngling.join(jedis)

      anakin.join(siths)
    end

    describe 'character attacking an ally' do
      it 'does not do anything' do
        obi_wan.deal_damage(youngling, 100)
        expect(youngling.health).to eq(1000)
      end
    end
  end

  describe 'character attacking another character' do
    context 'when character levels are similar' do
      it 'applies damage to the target character' do
        obi_wan.deal_damage(anakin, 50)
        expect(anakin.health).to eq(950)

        anakin.deal_damage(obi_wan, 200)
        expect(obi_wan.health).to eq(800)

        obi_wan.deal_damage(anakin, 1000)
        expect(anakin).not_to be_alive
      end
    end

    context 'when target character is 5 or more levels above' do
      it 'reduces damage by 50%' do
        youngling.deal_damage(anakin, 10)
        expect(anakin.health).to eq(995)
      end
    end

    context 'when target character is 5 or more levels below' do
      it 'increases damage by 50%' do
        anakin.deal_damage(youngling, 500)
        expect(youngling.health).to eq(250)
      end
    end
  end
end
