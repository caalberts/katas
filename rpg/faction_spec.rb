require_relative './rpg'

RSpec.describe RPG::Faction do
  let(:name) { 'The Order of Phoenix' }

  subject { RPG::Faction.new(name: name) }

  it 'has a name' do
    expect(subject.name).to eq(name)
  end
end
