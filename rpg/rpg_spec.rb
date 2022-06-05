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

  describe '#attack' do
    let(:target) { Character.new }

    it 'deals damage to the target' do
      subject.attack(target, 100)

      expect(target.health).to eq(900)
    end
  end

  describe '#damaged' do
    it 'reduces health' do
      subject.damaged(10)

      expect(subject.health).to eq(990)
    end
  end
end
