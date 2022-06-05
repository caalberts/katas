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
end
