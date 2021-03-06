require_relative './rpg'

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

  describe '#can_damage?' do
    subject(:can_damage?) { game.can_damage?(from: source, to: target) }

    let(:source) { instance_double(RPG::Character) }

    context 'when the source and target are the same' do
      let(:target) { source }

      it { is_expected.to be_falsey }
    end

    context 'when the source and target are allied' do
      let(:source) { instance_double(RPG::Character, alive?: true, level: 5, health: 100) }
      let(:target) { instance_double(RPG::Character, alive?: true, level: 5, health: 100) }
      let(:faction) { instance_double(RPG::Faction) }

      before do
        game.join_faction(member: source, factions: [faction])
        game.join_faction(member: target, factions: [faction])
      end

      it { is_expected.to be_falsey }
    end

    context 'when the source and target are not allied' do
      let(:source) { instance_double(RPG::Character, alive?: true, level: 5, health: 100) }
      let(:target) { instance_double(RPG::Character, alive?: true, level: 5, health: 100) }

      it { is_expected.to be_truthy }
    end
  end

  describe '#actual_damage_amount_for' do
    let(:amount) { 100 }
    let(:source) { instance_double(RPG::Character, level: 10) }
    let(:target) { instance_double(RPG::Character, level: 9) }

    subject { game.actual_damage_amount_for(source: source, target: target, amount: amount) }

    context 'when source and target are of similar level' do
      it { is_expected.to eq(amount) }
    end

    context 'when the target is 5 levels or below the source' do
      let(:source) { instance_double(RPG::Character, level: 10) }
      let(:target) { instance_double(RPG::Character, level: 5) }

      it { is_expected.to eq(1.5 * amount) }
    end

    context 'when the target is 5 levels or above the source' do
      let(:source) { instance_double(RPG::Character, level: 5) }
      let(:target) { instance_double(RPG::Character, level: 10) }

      it { is_expected.to eq(0.5 * amount) }
    end

    context 'when the target does not have a level' do
      let(:target) { instance_double(RPG::MagicalObject) }

      it { is_expected.to eq(amount) }
    end
  end

  describe '#can_heal?' do
    subject(:can_heal?) { game.can_heal?(from: source, to: target) }

    context 'when the source and target are the same' do
      let(:source) { instance_double(RPG::Character, alive?: true, level: 5, health: 100) }
      let(:target) { source }

      it { is_expected.to be_truthy }
    end

    context 'when the target is dead' do
      let(:source) { instance_double(RPG::Character, alive?: false) }
      let(:target) { source }

      it { is_expected.to be_falsey }
    end

    context 'when the source and target are allied' do
      let(:source) { instance_double(RPG::Character, alive?: true, level: 5, health: 100) }
      let(:target) { instance_double(RPG::Character, alive?: true, level: 5, health: 100) }
      let(:faction) { instance_double(RPG::Faction) }

      before do
        game.join_faction(member: source, factions: [faction])
        game.join_faction(member: target, factions: [faction])
      end

      it { is_expected.to be_truthy }
    end

    context 'when the source and target are not allied' do
      let(:source) { instance_double(RPG::Character, alive?: true, level: 5, health: 100) }
      let(:target) { instance_double(RPG::Character, alive?: true, level: 5, health: 100) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#actual_heal_amount_for' do
    subject { game.actual_heal_amount_for(target: target, amount: amount) }

    context 'when character level is below 6' do
      let(:target) { instance_double(RPG::Character, level: 5, health: 500) }

      context 'when the amount is more than the maximum health' do
        let(:amount) { 1000 }

        it 'returns the amount needed to maximum health 1000' do
          expect(subject).to eq(500)
        end
      end

      context 'when the amount is less than or equal the maximum health' do
        let(:amount) { 100 }

        it 'returns the given amount' do
          expect(subject).to eq(amount)
        end
      end
    end

    context 'when character level is 6 or above' do
      let(:target) { instance_double(RPG::Character, level: 6, health: 800) }

      context 'when the amount is more than the maximum health' do
        let(:amount) { 1000 }

        it 'returns the amount needed to maximum health 1500' do
          expect(subject).to eq(700)
        end
      end

      context 'when the amount is less than or equal the maximum health' do
        let(:amount) { 100 }

        it 'returns the given amount' do
          expect(subject).to eq(amount)
        end
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
