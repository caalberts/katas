require_relative './rpg'

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
