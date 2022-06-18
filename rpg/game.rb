require_relative './rpg'

module RPG
  class Game
    attr_reader :characters, :factions, :items

    def initialize
      @characters = []
      @factions = {}
      @items = []
    end

    def create_character(level: 1)
      RPG::Character.new(level: level, game: self).tap do |character|
        @characters << character
      end
    end

    def create_faction(name:)
      RPG::Faction.new(name: name).tap do |faction|
        @factions[faction] = []
      end
    end

    def create_item(health:)
      RPG::MagicalObject.new(health: health, game: self).tap do |item|
        @items << item
      end
    end

    def create_weapon(health:, damage:)
      RPG::MagicalWeapon.new(health: health, damage: damage, game: self).tap do |item|
        @items << item
      end
    end

    def deal_damage(from:, to:, amount:)
      return if from == to
      return if allied?(from, to)

      modifier = damage_modifier_for(source: from, target: to)

      to.take_damage(amount * modifier)
    end

    def actual_heal_amount_for(target:, amount:)
      max_health = max_health_for(target)

      max_heal_amount = max_health - target.health

      return max_heal_amount if amount >= max_heal_amount

      amount
    end

    HIGH_LEVEL = 6
    MAX_HEALTH_LOW = 1000
    MAX_HEALTH_HIGH = 1500

    def can_heal?(from:, to:)
      return false unless to.alive?

      from == to || allied?(from, to)
    end

    def join_faction(member:, factions:)
      factions.each do |faction|
        self.factions[faction] ||= []
        self.factions[faction] << member
      end
    end

    def leave_faction(member:, factions:)
      factions.each do |faction|
        self.factions[faction] ||= []
        self.factions[faction].delete_if { |m| m == member }
      end
    end

    def use(character:, object:)
      object.apply_effect_to(target: character)
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

    def max_health_for(character)
      character.level >= 6 ? MAX_HEALTH_HIGH : MAX_HEALTH_LOW
    end

    def allied?(member1, member2)
      self.factions.any? { |_faction, members| members.include?(member1) && members.include?(member2) }
    end
  end
end
