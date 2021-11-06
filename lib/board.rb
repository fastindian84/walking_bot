require_relative './mini_bot.rb'
require 'matrix'

class Board
  class BoardError < StandardError; end

  attr_reader :rows, :columns

  def initialize(rows:, columns:)
    @rows = rows.to_i
    @columns = columns.to_i

    validate!
  end

  def bot?
    @bot != nil
  end

  def place_bot(asix_x, asix_y, bot)
    if bot?
      @bot.move(asix_x, asix_y, face)
    else
      @bot = bot
    end
  end

  private

  def validate!
    if [rows, columns].any? { |v| v <= 0 }
      raise BoardError, 'rows and columns should greater or equal 1'
    end
  end

  def matrix
    @matrix ||= Matrix.zero(@rows, @columns)
  end


  def to_s
    list = @matrix.to_a
    columns_size = list[0].size - 1

    column_width = Math.log10(columns_size).to_i + 1
    index_column_width =  Math.log10(list.size).to_i + 2

    string = ''

    # HEADER
    string << ' ' * index_column_width
    string << (('_' * column_width) + ' ') * (columns_size +  1)
    string << "\n"


    list.reverse.each_with_index do |column, column_index|
      string << (list.size - column_index - 1).to_s

      column.each_with_index do |row, row_index|
        string << "|" if row_index == 0
        string << "_" * column_width
        string << "|"
      end

      string << "\n"
    end

    string << ' ' * index_column_width

    (0..columns_size).each do |number|
      string_number = number.to_s

      string << string_number

      if string_number.length < column_width
        string << ' ' * (column_width - string_number.length)
      end

      string << ' '
    end

    string << "\n"


    puts string
  end

  def report

  end
end
