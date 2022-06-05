InvalidActionError = Class.new(StandardError)

class Character
  HIGH_LEVEL = 6
  MAX_HEALTH_LOW = 1000
  MAX_HEALTH_HIGH = 1500

  attr_reader :health, :level

  def initialize(level: 1)
    @health = 1000
    @alive = true
    @level = level
  end

  def alive?
    @alive
  end

  def deal_damage(target, amount)
    raise InvalidActionError, 'a character cannot deal damage to itself' if target == self

    target.take_damage(amount)
  end

  def heal(amount)
    raise InvalidActionError, 'a dead character cannot heal' unless alive?

    @health += amount
    @health = max_health if @health > max_health
  end

  def take_damage(amount)
    @health -= amount
    @alive = false if @health <= 0
  end

  private

  def max_health
    high_level? ? MAX_HEALTH_HIGH : MAX_HEALTH_LOW
  end

  def high_level?
    level >= HIGH_LEVEL
  end
end
