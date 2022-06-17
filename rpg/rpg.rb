module RPG
  InvalidActionError = Class.new(StandardError)

  class Character
    HIGH_LEVEL = 6
    MAX_HEALTH_LOW = 1000
    MAX_HEALTH_HIGH = 1500

    attr_reader :health, :level

    def initialize(level: 1, game:)
      @health = 1000
      @level = level
      @game = game
    end

    def alive?
      @health > 0
    end

    def join(*factions)
      game.join_faction(member: self, factions: factions)
    end

    def leave(*factions)
      game.leave_faction(member: self, factions: factions)
    end

    def deal_damage(target, amount)
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
    attr_reader :name

    def initialize(name:)
      @name = name
    end
  end
end
