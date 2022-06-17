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

  xdescribe '#heal' do
    context 'when healing itself' do
      let(:target) { subject }
      let(:amount) { 100 }

      it 'increases target health by the given amount' do
        expect(subject).to receive(:increase_health).with(amount)

        subject.heal(target, amount)
      end

      context 'when character is dead' do
        before do
          target.take_damage(1001)
        end

        it 'cannot heal a dead target' do
          expect { subject.heal(target, 1) }.to raise_error(RPG::InvalidActionError, 'a dead character cannot be healed')
        end
      end
    end

    context 'when a target is an ally' do
      let(:alliance) { RPG::Faction.new(name: 'Allies') }

      before do
        subject.join(alliance)
        target.join(alliance)
      end

      let(:target) { described_class.new(game: game) }
      let(:amount) { 100 }

      it 'increases target health by the given amount' do
        expect(target).to receive(:increase_health).with(amount)

        subject.heal(target, amount)
      end
    end

    context 'when a target is not an ally' do
      let(:target) { described_class.new(game: game) }
      let(:amount) { 100 }

      it 'cannot heal a non-ally' do
        expect { subject.heal(target, amount) }.to raise_error(RPG::InvalidActionError, 'a non-ally cannot be healed')
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

    context 'when character level is below 6' do
      subject { described_class.new(level: 5, game: game) }

      it 'has maximum health of 1000' do
        subject.increase_health(2000)

        expect(subject.health).to eq(1000)
      end
    end

    context 'when character level is 6' do
      subject { described_class.new(level: 6, game: game) }

      it 'has maximum health of 1500' do
        subject.increase_health(2000)

        expect(subject.health).to eq(1500)
      end
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
end

RSpec.describe RPG::MagicalObject do
  let(:health) { 100 }

  subject { described_class.new(health: health) }

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
