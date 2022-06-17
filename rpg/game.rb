require_relative './rpg'

module RPG
  class Game
    attr_reader :characters, :factions

    def initialize
      @characters = []
      @factions = []
    end

    def create_character
      RPG::Character.new.tap do |character|
        @characters << character
      end
    end

    def create_faction(name:)
      RPG::Faction.new(name: name).tap do |faction|
        @factions << faction
      end
    end
  end
end
