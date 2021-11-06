require 'spec_helper'

describe Simulation do
  let(:bord) { Board.new(rows: 5, columns: 5) }
  let(:robot) { Robot.new(Robot::NORTH) }
  let(:simulation) { Simulation.new(bord) }

  describe '#place_bot' do
    it 'puts robot under certain position' do
      simulation.place_bot(robot, row: 3, column: 2)

      expect(robot.position).to eq [3, 2]
      expect(bord.available?(3, 2)).to eq false
    end

    it 'it sets maximum of available position' do
      simulation.place_bot(robot, row: 10, column: 10)

      expect(robot.position).to eq [4, 4]
      expect(bord.available?(4, 4)).to eq false
    end

    it 'replaces robot position' do
      simulation.place_bot(robot, row: 3, column: 2)
      expect(robot.position).to eq [3, 2]
      expect(bord.available?(3, 2)).to eq false

      simulation.place_bot(robot, row: 4, column: 2)
      expect(bord.available?(3, 2)).to eq true
      expect(robot.position).to eq [4, 2]
      expect(bord.available?(4, 2)).to eq false
    end
  end

  context 'actions' do
    before do
      simulation.place_bot(robot, row: 0, column: 0)
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
        simulation.place_bot(robot, row: 4, column: 0)
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
        simulation.place_bot(robot, row: 0, column: 3)
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
        simulation.place_bot(robot, row: 0, column: 4)
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

      simulation.place_bot(robot, row: 0, column: 0)
      simulation.move

      expect(simulation.report).to eq [0, 1, 'NORTH']
    end

    it 'submission 2' do
      robot = Robot.new(Robot::EAST)

      simulation.place_bot(robot, row: 2, column: 1)
      simulation.move
      simulation.move
      simulation.left
      simulation.move

      expect(simulation.report).to eq [3, 3, 'NORTH']
    end

    it 'submission 3' do
      robot = Robot.new(Robot::NORTH)

      simulation.place_bot(robot, row: 3, column: 1)
      simulation.move
      simulation.move
      simulation.right
      simulation.move

      expect(simulation.report).to eq [2, 4, 'EAST']
    end

    it 'submission 4' do
      robot = Robot.new(Robot::NORTH)

      simulation.place_bot(robot, row: 0, column: 0)
      simulation.left
      expect(simulation.report).to eq [0, 0, 'WEST']
    end
  end
end
