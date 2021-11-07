require_relative './presenters/board_presenter.rb'
require_relative './services/path_finder_service.rb'

class Simulation
  attr_reader :robot, :board

  def initialize(board)
    @board = board
  end

  def place_robot(robot, row:, column:)
    column = [column, board.columns - 1].min
    row = [row, board.rows - 1].min

    @robot = robot

    move_to(row, column)
  end

  def place_obstacle(row, column)
    board.place_obstacle(row, column)
  end

  def report
    [robot.column, robot.row, robot.face]
  end

  def pretty
    Presenters::BoardPresenter.call(board, robot)
  end

  def short_path(row, column)
    Services::PathFinderService.new(board, robot).to(row, column)
  end

  def move
    step(*robot.next_step_forward)
  end

  def left
    robot.turn_left!
  end

  def right
    robot.turn_right!
  end

  private

  def step(row, column)
    move_to(row, column) if board.available?(row, column)
  end

  def move_to(row, column)
    board.free_cell(*robot.position) if robot.position?

    robot.position = [row, column]

    board.place_robot(*robot.position)
  end
end
