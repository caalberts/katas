require_relative './rpg'

module RPG
  class Game
    attr_reader :characters, :factions, :items

    def initialize
      @characters = []
      @factions = []
      @items = []
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

    def create_item(health:)
      RPG::MagicalObject.new(health: health).tap do |item|
        @items << item
      end
    end
  end
end
