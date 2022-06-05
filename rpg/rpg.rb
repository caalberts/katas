InvalidActionError = Class.new(StandardError)

class Character
  HIGH_LEVEL = 6
  MAX_HEALTH_LOW = 1000
  MAX_HEALTH_HIGH = 1500

  attr_reader :health, :level, :factions

  def initialize(level: 1)
    @health = 1000
    @alive = true
    @level = level
    @factions = []
  end

  def alive?
    @alive
  end

  def join(*factions)
    factions.each do |faction|
      @factions.append(faction)
      faction.add_member(self)
    end
  end

  def leave(*factions)
    @factions -= factions
  end

  def damage_modifier_for(target)
    level_difference = target.level - self.level

    case
    when level_difference >= 5 then 0.5
    when level_difference <= -5 then 1.5
    else 1
    end
  end

  def deal_damage(target, amount)
    raise InvalidActionError, 'a character cannot deal damage to itself' if target == self
    raise InvalidActionError, 'a character cannot deal damage to an ally' if allied_with?(target)

    modifier = damage_modifier_for(target)

    target.take_damage(modifier * amount)
  end

  def heal(target, amount)
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

  def allied_with?(target)
    (target.factions & self.factions).any?
  end
end

class Faction
  attr_reader :name, :members

  def initialize(name:)
    @name = name
    @members = []
  end

  def add_member(member)
    @members.append(member)
  end
end
