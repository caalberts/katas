module RPG
  class MagicalObject
    attr_reader :health

    def initialize(health:, game:)
      @health = health
      @game = game
    end

    def take_damage(amount)
      @health -= amount
    end

    def destroyed?
      @health <= 0
    end

    def apply_effect_to(target:)
      heal_amount = game.actual_heal_amount_for(target: target, amount: health)

      target.increase_health(heal_amount)
      self.take_damage(heal_amount)
    end

    private

    attr_reader :game
  end
end
