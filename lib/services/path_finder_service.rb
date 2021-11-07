require 'set'

module Services
  class PathFinderService
    attr_reader :robot, :column

    def initialize(board, robot)
      @board = board
      @robot = robot
      @queue = []
      @visited = Set.new
    end

    def to(row, column)
      @destination = [row, column]

      path = find_path

      path ? translate(path) : ['unreachable']
    end

    private

    def translate(branch)
      coords = []

      clone = robot.clone

      while branch[:prev]
        coords.unshift(branch[:node])
        branch = branch[:prev]
      end

      path = []

      coords.each do |(next_row, next_column)|
        position_row, position_column = clone.position

        loop do
          # Need to go EAST
          if next_row == position_row && position_column > next_column
            break if clone.west?

            path.push(turn_clone(clone, Robot::WEST))
            # Need to go to EAST
          elsif next_row == position_row && position_column < next_column
            break if clone.east?

            path.push(turn_clone(clone, Robot::EAST))
            # Need to go to SOUTH
          elsif next_row < position_row && position_column == next_column
            break if clone.south?

            path.push(turn_clone(clone, Robot::SOUTH))
            # Need to go to NORTH
          elsif next_row > position_row && position_column == next_column
            break if clone.north?

            path.push(turn_clone(clone, Robot::NORTH))
          end
        end

        path.push('move')
        clone.position = [next_row, next_column]
      end

      path
    end

    def turn_clone(clone, side)
      if clone.right_side == side
        clone.turn_right!
        'right'
      else
        clone.turn_left!
        'left'
      end
    end

    def find_path
      node = { node: robot.position }

      @queue.push(node)

      while @queue.length.positive?
        prev = @queue.shift

        neighbors(prev[:node]).each do |neighobr|
          next if @visited.add?(neighobr).nil?

          other = { node: neighobr, prev: prev }

          @queue.push(other)

          return other if neighobr == @destination
        end
      end
    end

    def neighbors(cords)
      [
        next_cords(*cords, :up),
        next_cords(*cords, :down),
        next_cords(*cords, :left),
        next_cords(*cords, :right)
      ].compact
    end

    def next_cords(row, column, side)
      cords = case side
              when :up then [row + 1, column]
              when :down then [row - 1, column]
              when :right then [row, column + 1]
              when :left then [row, column - 1]
              end

      @board.available?(*cords) ? cords : nil
    end
  end
end
