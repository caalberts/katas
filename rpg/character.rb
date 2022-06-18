module RPG
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
      return unless game.can_heal?(from: self, to: target)

      heal_amount = game.actual_heal_amount_for(target: target, amount: amount)

      target.increase_health(heal_amount)
    end

    def increase_health(amount)
      @health += amount
    end

    def take_damage(amount)
      @health -= amount
    end

    def use(object)
      game.use(character: self, object: object)
    end

    private

    attr_reader :game

    def high_level?
      level >= HIGH_LEVEL
    end
  end
end
