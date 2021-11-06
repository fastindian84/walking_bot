module Presenters
  class BoardPresenter
    def self.call(board, robot)
      printable = BoardPresenter.new(board, robot)
      printable.print
    end

    attr_reader :output, :robot

    def initialize(board, robot)
      @board = board
      @robot = robot
    end

    def print
      [header, body, footer].join('')
    end

    private

    def table
      @table ||= @board.table.to_a.reverse
    end

    def columns
      table[0].size
    end

    def column_width
      @column_width ||= columns == 1 ? 2 : Math.log10(columns - 1).to_i + 1
    end

    def index_column_width
      @index_column_width ||= Math.log10(table.size).to_i + 1
    end

    def header
      @header ||= begin
                    header = ''
                    header << (' ' * index_column_width + ' ')
                    header << (('_' * column_width) + ' ') * columns
                    header.sub!(/\s$/, "\n")
                  end
    end

    def body
      body = []

      table.each_with_index do |column, column_index|
        add_column_index(body, column_index)

        column.each_with_index do |row, row_index|
          cell = ''
          cell << '|' if row_index.zero?

          if row == 1
            cell << robot.face_sign
            cell << '_' * (column_width - 1)
          else
            cell << '_' * column_width
          end

          cell << '|'

          body << cell
        end

        body << "\n"
      end

      body
    end

    def add_column_index(body, index)
      number_string = (table.size - index - 1).to_s

      body << number_string

      body << ' ' * (index_column_width - number_string.length) if number_string.length < index_column_width
    end

    def footer
      @footer = begin
                  footer = ''

                  footer << ' ' * index_column_width + ' '

                  (0...columns).each do |number|
                    string_number = number.to_s

                    footer << string_number

                    footer << ' ' * (column_width - string_number.length) if string_number.length < column_width
                    footer << ' '
                  end
                  footer.sub!(/\s$/, "\n")
                end
    end
  end
end
