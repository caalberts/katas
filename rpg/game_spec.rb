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
      expect(game.factions[faction]).to be_empty
    end

    describe '#create_item' do
      let(:health) { 100 }

      subject(:item) { game.create_item(health: health) }

      it 'adds item to the game' do
        expect(game.items).to contain_exactly(item)
      end
    end
  end

  describe '#deal_damage' do
    let(:source) { instance_double(RPG::Character) }
    let(:target) { instance_double(RPG::Character) }
    let(:amount) { 100 }

    subject(:deal_damage) { game.deal_damage(from: source, to: target, amount: amount) }

    context 'when the characters are similar level' do
      let(:source) { instance_double(RPG::Character, level: 10) }
      let(:target) { instance_double(RPG::Character, level: 9) }

      it 'asks the target to take the damage amount' do
        expect(target).to receive(:take_damage).with(amount)

        deal_damage
      end
    end

    context 'when the target is 5 levels or below the source' do
      let(:source) { instance_double(RPG::Character, level: 10) }
      let(:target) { instance_double(RPG::Character, level: 5) }

      it 'asks the target to take 50% more damage' do
        expect(target).to receive(:take_damage).with(1.5 * amount)

        deal_damage
      end
    end

    context 'when the target is 5 levels or above the source' do
      let(:source) { instance_double(RPG::Character, level: 5) }
      let(:target) { instance_double(RPG::Character, level: 10) }

      it 'asks the target to take 50% less damage' do
        expect(target).to receive(:take_damage).with(0.5 * amount)

        deal_damage
      end
    end

    context 'when the source and target are the same' do
      let(:source) { instance_double(RPG::Character, level: 5) }
      let(:target) { source }

      it 'does not ask the target to take damage' do
        expect(target).not_to receive(:take_damage)

        deal_damage
      end
    end

    context 'when the characters are allied' do
      let(:source) { instance_double(RPG::Character) }
      let(:target) { instance_double(RPG::Character) }
      let(:faction) { instance_double(RPG::Faction) }

      before do
        game.join_faction(member: source, factions: [faction])
        game.join_faction(member: target, factions: [faction])
      end

      it 'does not ask the target to take damage' do
        expect(target).not_to receive(:take_damage)

        deal_damage
      end
    end
  end

  describe '#join_faction' do
    let(:member) { instance_double(RPG::Character) }
    let(:faction1) { instance_double(RPG::Faction) }
    let(:faction2) { instance_double(RPG::Faction) }

    subject(:join_faction) { game.join_faction(member: member, factions: [faction1, faction2]) }

    it 'adds member to the factions' do
      join_faction

      expect(game.factions[faction1]).to contain_exactly(member)
      expect(game.factions[faction2]).to contain_exactly(member)
    end
  end

  describe '#leave_faction' do
    let(:member) { instance_double(RPG::Character) }
    let(:faction1) { instance_double(RPG::Faction) }
    let(:faction2) { instance_double(RPG::Faction) }

    subject(:leave_faction) { game.leave_faction(member: member, factions: [faction1, faction2]) }

    before do
      game.join_faction(member: member, factions: [faction1, faction2])
    end

    it 'removes member from the factions' do
      leave_faction

      expect(game.factions[faction1]).to be_empty
      expect(game.factions[faction2]).to be_empty
    end
  end
end
