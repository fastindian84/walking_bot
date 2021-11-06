require_relative './presenters/board_presenter.rb'

class Simulation
  attr_reader :robot, :board

  def initialize(board)
    @board = board
  end

  def place_bot(robot, row:, column:)
    column = [column, board.columns - 1].min
    row = [row, board.rows - 1].min

    @robot = robot

    move_to(row, column)
  end

  def report
    [robot.column, robot.row, robot.face]
  end

  def pretty
    Presenters::BoardPresenter.call(board, robot)
  end

  def move
    step(*next_step)
  end

  def left
    robot.turn_left!
  end

  def right
    robot.turn_right!
  end

  def step(row, column)
    move_to(row, column) if board.available?(row, column)
  end

  private

  def next_step
    if robot.north?
      [robot.row + 1, robot.column]
    elsif robot.south?
      [robot.row - 1, robot.column]
    elsif robot.west?
      [robot.row, robot.column - 1]
    elsif robot.east?
      [robot.row, robot.column + 1]
    end
  end

  def move_to(row, column)
    board.free_cell(*robot.position) if robot.position?

    robot.position = [row, column]

    board.fill_cell(*robot.position)
  end
end
