require_relative './rpg'

RSpec.describe RPG::Character do
  let(:game) { instance_double(RPG::Game) }

  subject { described_class.new(game: game) }

  describe 'initial character' do
    it 'starts with 1000 health' do
      expect(subject.health).to eq(1000)
    end

    it 'is alive' do
      expect(subject.alive?).to be(true)
    end

    it 'is at level 1' do
      expect(subject.level).to eq(1)
    end
  end

  describe '#deal_damage' do
    let(:amount) { 100 }
    let(:target) { described_class.new(game: game) }
    let(:damage_amount) { 50 }

    context 'when target can be damaged' do
      it 'reduces target health by amount after modifier' do
        expect(game).to receive(:can_damage?).with(from: subject, to: target).and_return(true)
        expect(game).to receive(:actual_damage_amount_for).with(source: subject, target: target, amount: amount).and_return(damage_amount)
        expect(target).to receive(:take_damage).with(damage_amount)

        subject.deal_damage(target, amount)
      end
    end

    context 'when damage is not provided' do
      context 'and there is a weapon' do
        let(:weapon) { instance_double(RPG::MagicalWeapon, damage: 10) }

        before do
          allow(subject).to receive(:weapon).and_return(weapon)
        end

        it 'deals weapon damage' do
          expect(game).to receive(:can_damage?).with(from: subject, to: target).and_return(true)
          expect(game).to receive(:actual_damage_amount_for).with(source: subject, target: target, amount: weapon.damage).and_return(damage_amount)
          expect(target).to receive(:take_damage).with(damage_amount)

          subject.deal_damage(target)
        end
      end

      context 'and there is no weapon' do
        it 'deals 0 damage' do
          expect(game).to receive(:can_damage?).with(from: subject, to: target).and_return(true)
          expect(game).to receive(:actual_damage_amount_for).with(source: subject, target: target, amount: 0).and_return(0)
          expect(target).to receive(:take_damage).with(0)

          subject.deal_damage(target)
        end
      end
    end
  end

  describe '#heal' do
    let(:target) { described_class.new(game: game) }
    let(:amount) { 100 }
    let(:heal_amount) { 75 }

    context 'when target can be healed' do
      it 'increases target health' do
        expect(game).to receive(:can_heal?).with(from: subject, to: target).and_return(true)
        expect(game).to receive(:actual_heal_amount_for).with(target: target, amount: amount).and_return(heal_amount)
        expect(target).to receive(:increase_health).with(heal_amount)

        subject.heal(target, amount)
      end
    end
  end

  describe '#increase_health' do
    before do
      subject.take_damage(100)
    end

    it 'increases health' do
      subject.increase_health(50)

      expect(subject.health).to eq(950)
    end
  end

  describe '#take_damage' do
    it 'reduces health' do
      subject.take_damage(10)

      expect(subject.health).to eq(990)
    end

    context 'remaining health is greater than 0' do
      it 'is still alive' do
        subject.take_damage(999)

        expect(subject.alive?).to be(true)
      end
    end

    context 'remaining health is 0' do
      it 'dies' do
        subject.take_damage(1000)

        expect(subject.alive?).to be(false)
      end
    end

    context 'remaining health is less than 0' do
      it 'dies' do
        subject.take_damage(1001)

        expect(subject.alive?).to be(false)
      end
    end
  end

  describe '#join' do
    let(:faction_1) { instance_double(RPG::Faction) }
    let(:faction_2) { instance_double(RPG::Faction) }

    it 'asks the game engine to join factions' do
      expect(game).to receive(:join_faction).with(member: subject, factions: [faction_1, faction_2])

      subject.join(faction_1, faction_2)
    end
  end

  describe '#leave' do
    let(:faction_1) { instance_double(RPG::Faction) }
    let(:faction_2) { instance_double(RPG::Faction) }

    it 'asks the game engine to leave factions' do
      expect(game).to receive(:leave_faction).with(member: subject, factions: [faction_1, faction_2])

      subject.leave(faction_1, faction_2)
    end
  end

  describe '#use' do
    let(:object) { instance_double(RPG::MagicalObject) }

    it 'asks the game engine to use item' do
      expect(game).to receive(:use).with(character: subject, object: object)

      subject.use(object)
    end
  end
end
