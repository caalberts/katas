module RPG
  class Faction
    attr_reader :name

    def initialize(name:)
      @name = name
    end
  end
end
