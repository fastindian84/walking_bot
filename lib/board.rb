require_relative './robot.rb'
require 'matrix'

class Board
  class BoardError < StandardError; end
  class OutOfRangeError < StandardError; end

  EMPTY_CELL = 0
  BOT_CELL = 1
  OBSTACLE_CELL = 2

  attr_reader :rows, :columns, :bot, :position

  def initialize(rows:, columns:)
    @rows = rows.to_i
    @columns = columns.to_i

    validate!
  end

  def place_obstacle(row, column)
    update_cell(OBSTACLE_CELL, row, column)
  end

  def place_robot(row, column)
    update_cell(BOT_CELL, row, column)
  end

  def free_cell(row, column)
    update_cell(EMPTY_CELL, row, column)
  end

  def table
    @table ||= Matrix.zero(@rows, @columns)
  end

  def available?(row, column)
    [row, column].all? { |v| v >= 0 } && table[row, column] == EMPTY_CELL
  end

  private

  def update_cell(val, row, column)
    raise OutOfRangeError, "[#{row}, #{column}] - Invalid coordinates" unless valid_coordinate?(row, column)

    table[row, column] = val
  end

  def valid_coordinate?(row, column)
    [row, column].all? { |v| v.is_a?(Integer) && v >= 0 } &&
      row < @rows && column < @columns
  end

  def validate!
    return unless [rows, columns].any? { |v| v <= 0 }

    raise BoardError, 'rows and columns should greater or equal 1'
  end
end
