require_relative './game'

RSpec.describe 'RPG Integration Specs' do
  let!(:game) { RPG::Game.new }
  let!(:jedis) { game.create_faction(name: 'Jedis') }
  let!(:rebels) { game.create_faction(name: 'Rebels') }
  let!(:siths) { game.create_faction(name: 'Siths') }
  let!(:empire) { game.create_faction(name: 'Empire') }
  let!(:obi_wan) { game.create_character(level: 8) }
  let!(:anakin) { game.create_character(level: 9) }
  let!(:youngling) { game.create_character(level: 1) }
  let!(:chewy) { game.create_character(level: 4) }
  let!(:stormtrooper) { game.create_character(level: 3) }
  let!(:bactasuit) { game.create_item(health: 800) }
  let!(:lightsaber) { game.create_weapon(health: 100, damage: 200) }
  let!(:blaster) { game.create_weapon(health: 10, damage: 10) }
  let!(:crossbow) { game.create_weapon(health: 20, damage: 100) }

  describe 'an RPG story' do
    context 'with alliances' do
      before do
        obi_wan.join(jedis)
        youngling.join(jedis)
        obi_wan.join(rebels)
        chewy.join(rebels)

        anakin.join(siths)
        anakin.join(empire)
        stormtrooper.join(empire)
      end

      it 'tells of enemies fighting and dying' do
        obi_wan.deal_damage(anakin, 50)
        anakin.deal_damage(obi_wan, 200)
        obi_wan.heal(anakin, 100)
        obi_wan.deal_damage(anakin, 1000)

        obi_wan.heal(obi_wan, 100)

        expect(obi_wan.health).to eq(900)
        expect(anakin).not_to be_alive

        obi_wan.use(bactasuit)

        expect(obi_wan.health).to eq(1500)
      end

      it 'tells of a helpless fight between the weak and the villain' do
        anakin.deal_damage(youngling, 400)
        youngling.deal_damage(anakin, 10)
        anakin.deal_damage(youngling, 400)

        obi_wan.heal(youngling, 100)

        expect(anakin.health).to eq(995)
        expect(youngling).not_to be_alive
      end

      it 'tells of fights using weapons and items' do
        obi_wan.use(lightsaber)
        obi_wan.deal_damage(stormtrooper) # obi_wan deals 1.5 damage
        stormtrooper.use(blaster)
        stormtrooper.deal_damage(chewy)
        chewy.use(crossbow)
        chewy.deal_damage(stormtrooper)

        expect(obi_wan.health).to eq(1000)
        expect(stormtrooper.health).to eq(600)
        expect(chewy.health).to eq(990)
        expect(lightsaber.health).to eq(99)
        expect(blaster.health).to eq(9)
        expect(crossbow.health).to eq(19)

        obi_wan.use(bactasuit)
        chewy.use(bactasuit)

        expect(obi_wan.health).to eq(1500)
        expect(chewy.health).to eq(1000)

        obi_wan.deal_damage(blaster)

        expect(lightsaber.health).to eq(98)
        expect(blaster).to be_destroyed
        expect(crossbow.health).to eq(19)
      end
    end
  end
end
