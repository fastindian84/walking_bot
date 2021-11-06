require 'spec_helper'

describe Robot do
  it 'validate params' do
    expect { Robot.new('f') }.to raise_error(Robot::BotError)
    expect { Robot.new(0) }.to raise_error(Robot::BotError)

    expect { Robot.new('NORTH') }.to_not raise_error
    expect { Robot.new('SOUTH') }.to_not raise_error
    expect { Robot.new('EAST') }.to_not raise_error
    expect { Robot.new('WEST') }.to_not raise_error
  end

  it '#turn_left!' do
    robot = Robot.new(Robot::NORTH)

    robot.turn_left!
    expect(robot.face).to eq Robot::WEST

    robot.turn_left!
    expect(robot.face).to eq Robot::SOUTH

    robot.turn_left!
    expect(robot.face).to eq Robot::EAST

    robot.turn_left!
    expect(robot.face).to eq Robot::NORTH
  end

  it '#turn_right!' do
    robot = Robot.new(Robot::NORTH)

    robot.turn_right!
    expect(robot.face).to eq Robot::EAST

    robot.turn_right!
    expect(robot.face).to eq Robot::SOUTH

    robot.turn_right!
    expect(robot.face).to eq Robot::WEST

    robot.turn_right!
    expect(robot.face).to eq Robot::NORTH
  end
end
