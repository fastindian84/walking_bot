require 'spec_helper'

describe Simulation do
  let(:bord) { Board.new(rows: 5, columns: 5) }
  let(:robot) { Robot.new(Robot::NORTH) }
  let(:simulation) { Simulation.new(bord) }

  describe '#place_robot' do
    it 'puts robot under certain position' do
      simulation.place_robot(robot, row: 3, column: 2)

      expect(robot.position).to eq [3, 2]
      expect(bord.available?(3, 2)).to eq false
    end

    it 'it sets maximum of available position' do
      simulation.place_robot(robot, row: 10, column: 10)

      expect(robot.position).to eq [4, 4]
      expect(bord.available?(4, 4)).to eq false
    end

    it 'replaces robot position' do
      simulation.place_robot(robot, row: 3, column: 2)
      expect(robot.position).to eq [3, 2]
      expect(bord.available?(3, 2)).to eq false

      simulation.place_robot(robot, row: 4, column: 2)
      expect(bord.available?(3, 2)).to eq true
      expect(robot.position).to eq [4, 2]
      expect(bord.available?(4, 2)).to eq false
    end
  end

  context 'actions' do
    before do
      simulation.place_robot(robot, row: 0, column: 0)
    end

    describe '#move', 'robot NORTH' do
      it 'moves robot forward its direction' do
        simulation.move

        expect(robot.position).to eq [1, 0]
        expect(bord.available?(0, 0)).to eq true
        expect(bord.available?(1, 0)).to eq false
      end

      it 'moves robot forward its direction until it reaches top boundary' do
        10.times { simulation.move }

        expect(robot.position).to eq [4, 0]
        expect(bord.available?(0, 0)).to eq true
        expect(bord.available?(1, 0)).to eq true
        expect(bord.available?(2, 0)).to eq true
        expect(bord.available?(3, 0)).to eq true
        expect(bord.available?(4, 0)).to eq false
      end
    end

    describe '#move', 'robot SOUTH' do
      let(:robot) { Robot.new(Robot::SOUTH) }

      it 'moves robot forward its direction' do
        simulation.move

        expect(robot.position).to eq [0, 0]
        expect(bord.available?(0, 0)).to eq false
      end

      it 'moves robot forward its direction until it reaches top boundary' do
        simulation.place_robot(robot, row: 4, column: 0)
        expect(robot.position).to eq [4, 0]

        10.times { simulation.move }

        expect(robot.position).to eq [0, 0]
        expect(bord.available?(0, 0)).to eq false
        expect(bord.available?(1, 0)).to eq true
        expect(bord.available?(2, 0)).to eq true
        expect(bord.available?(3, 0)).to eq true
        expect(bord.available?(4, 0)).to eq true
      end
    end

    describe '#move', 'robot EAST' do
      let(:robot) { Robot.new(Robot::EAST) }

      before do
        simulation.place_robot(robot, row: 0, column: 3)
        expect(robot.position).to eq [0, 3]
      end

      it 'moves robot forward its direction' do
        simulation.move

        expect(robot.position).to eq [0, 4]
        expect(bord.available?(0, 3)).to eq true
        expect(bord.available?(0, 4)).to eq false
      end

      it 'moves robot forward its direction until it reaches top boundary' do
        10.times { simulation.move }

        expect(bord.available?(0, 0)).to eq true
        expect(bord.available?(0, 1)).to eq true
        expect(bord.available?(0, 2)).to eq true
        expect(bord.available?(0, 3)).to eq true
        expect(bord.available?(0, 4)).to eq false
      end
    end

    describe '#move', 'robot WEST' do
      let(:robot) { Robot.new(Robot::WEST) }

      before do
        simulation.place_robot(robot, row: 0, column: 4)
        expect(robot.position).to eq [0, 4]
      end

      it 'moves robot forward its direction' do
        simulation.move

        expect(robot.position).to eq [0, 3]
        expect(bord.available?(0, 3)).to eq false
        expect(bord.available?(0, 4)).to eq true
      end

      it 'moves robot forward its direction until it reaches top boundary' do
        10.times { simulation.move }

        expect(robot.position).to eq [0, 0]
        expect(bord.available?(0, 0)).to eq false
        expect(bord.available?(0, 1)).to eq true
        expect(bord.available?(0, 2)).to eq true
        expect(bord.available?(0, 3)).to eq true
        expect(bord.available?(0, 4)).to eq true
      end
    end
  end

  describe '#report' do
    it 'submission 1' do
      robot = Robot.new(Robot::NORTH)

      simulation.place_robot(robot, row: 0, column: 0)
      simulation.move

      expect(simulation.report).to eq [0, 1, 'NORTH']
    end

    it 'submission 2' do
      robot = Robot.new(Robot::EAST)

      simulation.place_robot(robot, row: 2, column: 1)
      simulation.move
      simulation.move
      simulation.left
      simulation.move

      expect(simulation.report).to eq [3, 3, 'NORTH']
    end

    it 'submission 3' do
      robot = Robot.new(Robot::NORTH)

      simulation.place_robot(robot, row: 3, column: 1)
      simulation.move
      simulation.move
      simulation.right
      simulation.move

      expect(simulation.report).to eq [2, 4, 'EAST']
    end

    it 'submission 4' do
      robot = Robot.new(Robot::NORTH)

      simulation.place_robot(robot, row: 0, column: 0)
      simulation.left
      expect(simulation.report).to eq [0, 0, 'WEST']
    end
  end

  describe 'obstacles' do
    let(:bord) { Board.new(rows: 10, columns: 10) }

    before do
      simulation.place_obstacle(2, 0)
      simulation.place_obstacle(1, 1)
      simulation.place_obstacle(1, 2)

      simulation.place_obstacle(3, 2)
      simulation.place_obstacle(3, 3)
      simulation.place_obstacle(3, 4)
      simulation.place_obstacle(3, 5)
      simulation.place_obstacle(2, 5)
      simulation.place_obstacle(1, 5)
    end

    #    _ _ _ _ _ _ _ _ _ _
    # 9 |_|_|_|_|_|_|_|_|_|_|
    # 8 |_|_|_|_|_|_|_|_|_|_|
    # 7 |_|_|_|_|_|_|_|_|_|_|
    # 6 |_|_|_|_|_|_|_|_|_|_|
    # 5 |_|_|_|_|_|_|_|_|_|_|
    # 4 |_|_|_|_|_|_|_|_|_|_|
    # 3 |_|_|+|+|+|+|_|_|_|_|
    # 2 |+|_|_|_|_|+|_|_|_|_|
    # 1 |_|+|+|_|_|+|_|_|_|_|
    # 0 |^|_|_|_|_|_|_|_|_|_|
    #    0 1 2 3 4 5 6 7 8 9
    it 'can bypass obstacles' do
      robot = Robot.new(Robot::NORTH)
      simulation.place_robot(robot, row: 0, column: 0)

      expect(simulation.short_path(4, 6)).to eq ['right', (['move'] * 6), 'left', (['move'] * 4)].flatten
    end

    it 'returns unreachable when point is not accessible' do
      robot = Robot.new(Robot::NORTH)
      simulation.place_robot(robot, row: 1, column: 0)

      expect(simulation.short_path(3, 4)).to eq ['unreachable'].flatten
    end

    it 'goes through labirint' do
      robot = Robot.new(Robot::NORTH)
      simulation.place_robot(robot, row: 1, column: 0)

      path = %w[left left move left move move move left move move left move move right move move right move move move]
      expect(simulation.short_path(4, 4)).to eq path
    end
  end
end
