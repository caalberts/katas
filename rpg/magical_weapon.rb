module RPG
  class MagicalWeapon
    attr_reader :health, :damage

    def initialize(health:, damage:, game:)
      @health = health
      @damage = damage
      @game = game
    end

    def take_damage(amount)
      @health -= amount
    end

    def destroyed?
      @health <= 0
    end

    def apply_effect_to(target:)
      target.weapon = self
      self.take_damage(1)
    end

    private

    attr_reader :game
  end
end
