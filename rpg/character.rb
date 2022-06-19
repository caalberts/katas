module RPG
  class Character
    HIGH_LEVEL = 6
    MAX_HEALTH_LOW = 1000
    MAX_HEALTH_HIGH = 1500

    DAMAGE_FOR_LEVEL_UP = 1000

    attr_reader :health, :level
    attr_writer :weapon

    def initialize(level: 1, game:)
      @health = 1000
      @level = level
      @game = game
      @accumulated_damage = 0
      @level_up_requirement = level * DAMAGE_FOR_LEVEL_UP
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

    def deal_damage(target, amount = nil)
      return unless game.can_damage?(from: self, to: target)
      actual_damage = game.actual_damage_amount_for(source: self, target: target, amount: amount || damage_from_weapon)

      target.take_damage(actual_damage)
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
      @accumulated_damage += amount

      level_up if accumulated_damage >= level_up_requirement
    end

    def use(object)
      object.apply_effect_to(target: self)
    end

    private

    attr_reader :game, :weapon, :accumulated_damage, :level_up_requirement

    def increase_level_up_requirement
      @level_up_requirement += level * DAMAGE_FOR_LEVEL_UP
    end

    def level_up
      @level += 1

      increase_level_up_requirement
    end

    def high_level?
      level >= HIGH_LEVEL
    end

    def damage_from_weapon
      return 0 unless weapon && !weapon.destroyed?

      weapon.take_damage(1)
      weapon&.damage
    end
  end
end
