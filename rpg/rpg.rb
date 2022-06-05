InvalidActionError = Class.new(StandardError)

class Character
  MAX_HEALTH = 1000

  attr_reader :health, :level

  def initialize
    @health = 1000
    @alive = true
    @level = 1
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
    @health = MAX_HEALTH if @health > MAX_HEALTH
  end

  def take_damage(amount)
    @health -= amount
    @alive = false if @health <= 0
  end
end
