require_relative './rpg'

module RPG
  class Game
    attr_reader :characters
    def initialize
      @characters = []
    end

    def create_character
      RPG::Character.new.tap do |character|
        @characters << character
      end
    end
  end
end
