class Robot
  class BotError < StandardError; end
  NORTH = 'NORTH'.freeze
  SOUTH = 'SOUTH'.freeze
  EAST = 'EAST'.freeze
  WEST = 'WEST'.freeze

  SIDES = [NORTH, EAST, SOUTH, WEST].freeze

  attr_reader :face
  attr_accessor :position

  def initialize(face)
    @face = face
    @position = []

    validate!
  end

  def turn_left!
    next_index = face_index - 1

    @face = SIDES[next_index] || SIDES[3]
  end

  def turn_right!
    next_index = face_index + 1

    @face = SIDES[next_index] || SIDES[0]
  end

  def row
    position[0]
  end

  def column
    position[1]
  end

  def position?
    position.any?
  end

  SIDES.each do |side|
    define_method("#{side.downcase}?") do
      side == face
    end
  end

  def face_sign
    case face
    when NORTH then '^'
    when SOUTH then 'V'
    when EAST then '>'
    when WEST then '<'
    end
  end

  private

  def face_index
    SIDES.index(face)
  end

  def valid_face?
    SIDES.include?(@face)
  end

  def validate!
    return if valid_face?

    raise BotError, "#{face} is not a valid option. Valid options are: #{SIDES.join(', ')}"
  end
end
