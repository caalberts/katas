require_relative './rpg'

RSpec.describe Character do
  describe 'initial character' do
    subject { Character.new }

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
end
