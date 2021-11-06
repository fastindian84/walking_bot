require 'spec_helper'

describe Presenters::BoardPresenter do
  let(:robot) { double }

  it 'prints board 11x11' do

    board = Board.new(columns: 11, rows: 11)
    expect(Presenters::BoardPresenter.new(board, robot).print).to eq <<-TABLE
   __ __ __ __ __ __ __ __ __ __ __
10|__|__|__|__|__|__|__|__|__|__|__|
9 |__|__|__|__|__|__|__|__|__|__|__|
8 |__|__|__|__|__|__|__|__|__|__|__|
7 |__|__|__|__|__|__|__|__|__|__|__|
6 |__|__|__|__|__|__|__|__|__|__|__|
5 |__|__|__|__|__|__|__|__|__|__|__|
4 |__|__|__|__|__|__|__|__|__|__|__|
3 |__|__|__|__|__|__|__|__|__|__|__|
2 |__|__|__|__|__|__|__|__|__|__|__|
1 |__|__|__|__|__|__|__|__|__|__|__|
0 |__|__|__|__|__|__|__|__|__|__|__|
   0  1  2  3  4  5  6  7  8  9  10
TABLE
  end

  it 'prints board 1x11' do
    board = Board.new(columns: 11, rows: 1)
    expect(Presenters::BoardPresenter.new(board, robot).print).to eq <<-TABLE
  __ __ __ __ __ __ __ __ __ __ __
0|__|__|__|__|__|__|__|__|__|__|__|
  0  1  2  3  4  5  6  7  8  9  10
TABLE
  end

  it 'prints board 11x1' do
    board = Board.new(columns: 1, rows: 11)
    expect(Presenters::BoardPresenter.new(board, robot).print).to eq <<~TABLE
   __
10|__|
9 |__|
8 |__|
7 |__|
6 |__|
5 |__|
4 |__|
3 |__|
2 |__|
1 |__|
0 |__|
   0\s
TABLE
  end
end
