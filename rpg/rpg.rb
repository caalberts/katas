class Character
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
    target.take_damage(amount)
  end

  def take_damage(amount)
    @health -= amount
    @alive = false if @health <= 0
  end
end
