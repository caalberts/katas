require_relative './rpg'

RSpec.describe RPG::Character do
  subject { described_class.new }

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

    it 'does not have any factions' do
      expect(subject.factions).to be_empty
    end
  end

  describe '#deal_damage' do
    let(:target) { described_class.new }

    it 'deals damage to the target' do
      subject.deal_damage(target, 100)

      expect(target.health).to eq(900)
    end

    it 'cannot deal damage to itself' do
      expect { subject.deal_damage(subject, 1) }.to raise_error(RPG::InvalidActionError, 'a character cannot deal damage to itself')
    end

    context 'when target is 5 or more levels above the attacker' do
      let(:target) { described_class.new(level: subject.level + 5) }

      it 'deals 50% less damage' do
        subject.deal_damage(target, 100)

        expect(target.health).to eq(950)
      end
    end

    context 'when target is 5 or more levels below the attacker' do
      subject { described_class.new(level: 10) }

      let(:target) { described_class.new(level: subject.level - 5) }

      it 'deals 50% more damage' do
        subject.deal_damage(target, 100)

        expect(target.health).to eq(850)
      end
    end

    context 'when target is an ally' do
      let(:alliance) { RPG::Faction.new(name: 'Allies') }

      before do
        subject.join(alliance)
        target.join(alliance)
      end

      it 'cannot deal damage to an ally' do
        expect { subject.deal_damage(target, 1) }.to raise_error(RPG::InvalidActionError, 'a character cannot deal damage to an ally')
      end
    end
  end

  describe '#heal' do
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

      let(:target) { described_class.new }
      let(:amount) { 100 }

      it 'increases target health by the given amount' do
        expect(target).to receive(:increase_health).with(amount)

        subject.heal(target, amount)
      end
    end

    context 'when a target is not an ally' do
      let(:target) { described_class.new }
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
      subject { described_class.new(level: 5) }

      it 'has maximum health of 1000' do
        subject.increase_health(2000)

        expect(subject.health).to eq(1000)
      end
    end

    context 'when character level is 6' do
      subject { described_class.new(level: 6) }

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
    let(:faction_1) { RPG::Faction.new(name: 'The Harpers') }
    let(:faction_2) { RPG::Faction.new(name: 'The Order of the Gauntlet') }
    let(:faction_3) { RPG::Faction.new(name: 'The Emerald Enclave') }

    it 'joins a faction' do
      subject.join(faction_1)

      expect(subject.factions).to contain_exactly(faction_1)
    end

    it 'can join multiple factions' do
      subject.join(faction_1, faction_2)

      expect(subject.factions).to contain_exactly(faction_1, faction_2)
    end

    context 'with existing faction' do
      before do
        subject.join(faction_1)
      end

      it 'can join additional factions' do
        subject.join(faction_2, faction_3)

        expect(subject.factions).to contain_exactly(faction_1, faction_2, faction_3)
      end
    end

    it 'adds member to the faction' do
      subject.join(faction_1)

      expect(faction_1.members).to contain_exactly(subject)
    end
  end

  describe '#leave' do
    let(:faction_1) { RPG::Faction.new(name: 'The Harpers') }
    let(:faction_2) { RPG::Faction.new(name: 'The Order of the Gauntlet') }
    let(:faction_3) { RPG::Faction.new(name: 'The Emerald Enclave') }

    before do
      subject.join(faction_1, faction_2)
    end

    it 'leaves a faction' do
      subject.leave(faction_1)

      expect(subject.factions).to contain_exactly(faction_2)
    end

    it 'can leave multiple factions' do
      subject.leave(faction_1, faction_2)

      expect(subject.factions).to be_empty
    end

    it 'does not do anything if it is not a member' do
      subject.leave(faction_3)

      expect(subject.factions).to contain_exactly(faction_1, faction_2)
    end
  end
end

RSpec.describe RPG::Faction do
  subject { RPG::Faction.new(name: 'The Order of Phoenix') }

  describe 'initial faction' do
    it 'has no members' do
      expect(subject.members).to be_empty
    end
  end

  describe '#add_member' do
    let(:member) { RPG::Character.new }

    it 'adds member to faction' do
      subject.add_member(member)

      expect(subject.members).to contain_exactly(member)
    end
  end
end
