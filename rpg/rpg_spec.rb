require_relative './rpg'

RSpec.describe Character do
  subject { Character.new }

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
    let(:target) { Character.new }

    it 'deals damage to the target' do
      subject.deal_damage(target, 100)

      expect(target.health).to eq(900)
    end

    it 'cannot deals damage to itself' do
      expect { subject.deal_damage(subject, 1) }.to raise_error(InvalidActionError, 'a character cannot deal damage to itself')
    end
  end

  describe '#heal' do
    before do
      subject.take_damage(100)
    end

    it 'heals itself by the given amount' do
      subject.heal(50)

      expect(subject.health).to eq(950)
    end

    context 'when character level is below 6' do
      subject { Character.new(level: 5) }

      it 'has maximum health of 1000' do
        subject.heal(2000)

        expect(subject.health).to eq(1000)
      end
    end

    context 'when character level is 6' do
      subject { Character.new(level: 6) }

      it 'has maximum health of 1500' do
        subject.heal(2000)

        expect(subject.health).to eq(1500)
      end
    end

    context 'when character is dead' do
      before do
        subject.take_damage(1001)
      end

      it 'cannot heal itself' do
        expect { subject.heal(1) }.to raise_error(InvalidActionError, 'a dead character cannot heal')
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
end
