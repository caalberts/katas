require_relative './rpg'

module RPG
  class Game
    attr_reader :characters, :factions, :items

    def initialize
      @characters = []
      @factions = []
      @items = []
    end

    def create_character(level: 1)
      RPG::Character.new(level: level, game: self).tap do |character|
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

    def deal_damage(from:, to:, amount:)
      return if from == to

      modifier = damage_modifier_for(source: from, target: to)

      to.take_damage(amount * modifier)
    end

    private

    def damage_modifier_for(source:, target:)
      level_difference = target.level - source.level

      case
      when level_difference >= 5 then 0.5
      when level_difference <= -5 then 1.5
      else 1
      end
    end
  end
end
