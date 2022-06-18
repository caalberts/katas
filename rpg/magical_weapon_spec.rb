require_relative './rpg'

RSpec.describe RPG::MagicalWeapon do
  let(:health) { 100 }
  let(:damage) { 10 }
  let(:game) { instance_double(RPG::Game) }

  subject { described_class.new(health: health, damage: damage, game: game) }

  describe 'initial magical weapon' do
    it 'starts with some health' do
      expect(subject.health).to eq(health)
    end

    it 'starts with some damage' do
      expect(subject.damage).to eq(damage)
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

    it 'sets character weapon to itself' do
      expect(target).to receive(:weapon=).with(subject)

      subject.apply_effect_to(target: target)
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
