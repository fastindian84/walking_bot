class Robot
  class BotError < StandardError; end
  NORTH = 'NORTH'.freeze
  SOUTH = 'SOUTH'.freeze
  EAST = 'EAST'.freeze
  WEST = 'WEST'.freeze

  SIDES = [NORTH, EAST, SOUTH, WEST].freeze

  attr_accessor :position, :face

  def initialize(face)
    @face = face
    @position = []
    validate!
  end

  def clone
    dup = Robot.new(face)
    dup.position = position
    dup
  end

  def left_side
    next_index = face_index - 1
    SIDES[next_index]
  end

  def right_side
    next_index = face_index + 1
    SIDES[next_index] || SIDES[0]
  end

  def turn_left!
    @face = left_side
  end

  def turn_right!
    @face = right_side
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

  def next_step_forward
    if north?
      [row + 1, column]
    elsif south?
      [row - 1, column]
    elsif west?
      [row, column - 1]
    elsif east?
      [row, column + 1]
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
