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

  def attack(target, damage)
    target.damaged(damage)
  end

  def damaged(amount)
    @health -= amount
  end
end
