require_relative './game'

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

    it 'asks game engine to deal damage to target' do
      expect(game).to receive(:deal_damage).with(from: subject, to: target, amount: amount)

      subject.deal_damage(target, amount)
    end
  end

  describe '#heal' do
    context 'when healing itself' do
      let(:target) { subject }
      let(:amount) { 100 }

      it 'asks the game engine to heal target by the amount' do
        expect(game).to receive(:heal).with(from: subject, to: target, amount: amount)

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

RSpec.describe RPG::MagicalObject do
  let(:health) { 100 }
  let(:game) { instance_double(RPG::Game) }

  subject { described_class.new(health: health, game: game) }

  describe 'initial magical object' do
    it 'starts with some health' do
      expect(subject.health).to eq(health)
    end
  end

  describe '#take_damage' do
    it 'reduces health' do
      subject.take_damage(10)

      expect(subject.health).to eq(health - 10)
    end
  end

  describe '#apply_effect_to' do
    let(:target) { instance_double(RPG::Character) }
    let(:heal_amount) { 50 }

    it 'asks game engine for actual heal amount and reduce its own health' do
      expect(game).to receive(:actual_heal_amount_for).with(target: target, amount: health)
        .and_return(heal_amount)
      expect(target).to receive(:increase_health).with(heal_amount)

      subject.apply_effect_to(target: target)

      expect(subject.health).to eq(health - heal_amount)
    end
  end

  describe '#destroyed?' do
    context 'remaining health is more than 0' do
      it 'is not destroyed' do
        expect(subject.destroyed?).to be(false)
      end
    end

    context 'remaining health is 0' do
      it 'is destroyed' do
        subject.take_damage(health)

        expect(subject.destroyed?).to be(true)
      end
    end

    context 'remaining health is less than 0' do
      it 'is destroyed' do
        subject.take_damage(health + 1)

        expect(subject.destroyed?).to be(true)
      end
    end
  end
end

RSpec.describe RPG::Faction do
  let(:name) { 'The Order of Phoenix' }

  subject { RPG::Faction.new(name: name) }

  it 'has a name' do
    expect(subject.name).to eq(name)
  end
end
