module RPG
  InvalidActionError = Class.new(StandardError)

  class Character
    HIGH_LEVEL = 6
    MAX_HEALTH_LOW = 1000
    MAX_HEALTH_HIGH = 1500

    attr_reader :health, :level, :factions

    def initialize(level: 1, game:)
      @health = 1000
      @level = level
      @factions = []
      @game = game
    end

    def alive?
      @health > 0
    end

    def join(*factions)
      factions.each do |faction|
        @factions.append(faction)
        faction.add_member(self)
      end
    end

    def leave(*factions)
      @factions -= factions
    end

    def deal_damage(target, amount)
      raise InvalidActionError, 'a character cannot deal damage to itself' if target == self
      raise InvalidActionError, 'a character cannot deal damage to an ally' if allied_with?(target)

      game.deal_damage(from: self, to: target, amount: amount)
    end

    def heal(target, amount)
      raise InvalidActionError, 'a dead character cannot be healed' unless alive?
      raise InvalidActionError, 'a non-ally cannot be healed' unless allied_with?(target) || target == self

      target.increase_health(amount)
    end

    def increase_health(amount)
      @health += amount
      @health = max_health if @health > max_health
    end

    def take_damage(amount)
      @health -= amount
    end

    private

    attr_reader :game

    def max_health
      high_level? ? MAX_HEALTH_HIGH : MAX_HEALTH_LOW
    end

    def high_level?
      level >= HIGH_LEVEL
    end

    def allied_with?(target)
      (target.factions & self.factions).any?
    end
  end

  class MagicalObject
    attr_reader :health

    def initialize(health:)
      @health = health
    end

    def take_damage(amount)
      @health -= amount
    end

    def destroyed?
      @health <= 0
    end
  end

  class Faction
    attr_reader :name, :members

    def initialize(name:)
      @name = name
      @members = []
    end

    def add_member(member)
      @members.append(member)
    end
  end
end
