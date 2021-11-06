class MiniBot
  class BotError < StandardError; end

  VALID_SIDES = ['NORTH', 'SOUTH', 'EAST', 'WEST']

  attr_reader :asix_y, :asix_x, :face

  def initialize(asix_x, asix_y, face)
    @asix_y = asix_x
    @asix_x = asix_y
    @face = face

    validate!
  end

  private

  def valid_face?
    VALID_SIDES.include?(@face)
  end

  def validate!
    if !valid_face?
      raise BotError, "#{face} is not a valid option. Valid options are: #{VALID_SIDES.join(', ')}"
    end
  end
end
