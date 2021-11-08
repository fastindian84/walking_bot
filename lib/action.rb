require_relative '../lib/simulation.rb'
require_relative '../lib/board.rb'
require_relative '../lib/robot.rb'

class Action
  def self.run
    board = Board.new(columns: 5, rows: 5)
    simulation = Simulation.new(board)

    new(simulation)
  end

  attr_reader :history, :display_mode, :robot, :simulation
  alias display_mode? display_mode

  def initialize(simulation)
    @simulation = simulation
    @display_mode = false
    @robot = nil
    @history = []
  end

  def commands
    {
      'PLACE' => proc { |args| place_action(args) },
      'MOVE' => proc { move },
      'LEFT' => proc { left },
      'RIGHT' => proc { right },
      'REPORT' => proc { report },
      'pretty' => proc { togge_disply_mode! },
      'clear' => proc { cear_history! }
    }
  end

  def report
    return if robot.nil?

    history.push "Output: #{simulation.report.join(',')}"
  end

  def right
    return if robot.nil?

    simulation.right
  end

  def left
    return if robot.nil?

    simulation.left
  end

  def move
    return if robot.nil?

    simulation.move
  end

  def cear_history!
    @history = []
  end

  def togge_disply_mode!
    @display_mode = !display_mode
  end

  def place_action(args)
    args
      .each { |a| a.gsub!(/[^\w+|\d+]/, '') }
      .reject! {|a| a.length.zero? }

    if args.size != 3
      history.push("Wrong number of arguments. #{args}")

      return
    end

    column, row, face = args

    unless Robot::SIDES.include?(face)
      history.push("Incorrect SIDE. Valid sides: #{Robot::SIDES.join(', ')}")
      return
    end

    if @robot
      @robot.face = face
    else
      @robot = Robot.new(face)
    end

    simulation.place_robot(robot, row: row, column: column)
  end

  def wait_loop
    loop do
      system("clear")
      puts simulation.pretty if display_mode?

      puts history.join("\n")

      user_input = gets.chomp

      command, *args = user_input.split(/\W/)

      break if command == 'exit'

      history.push(user_input)
      action = commands[command]

      next if action.nil?

      action.call(args)
    end
  end
end
