require 'spec_helper'

describe Board do
  describe 'validations' do
    it 'raise an excpetion with invalid params' do
      expect { Board.new(rows: '0', columns: 1) }.to raise_error Board::BoardError
      expect { Board.new(rows: '1', columns: 0) }.to raise_error Board::BoardError
      expect { Board.new(rows: '010', columns: 1) }.to_not raise_error
    end
  end

  context 'API' do
    let(:board) { Board.new(rows: 5, columns: 5) }

    it '#place_robot' do
      expect(board.table[3, 3]).to eq Board::EMPTY_CELL
      board.place_robot(3, 3)
      expect(board.table[3, 3]).to eq Board::BOT_CELL
    end

    it '#free_cell' do
      board.place_robot(3, 3)
      expect(board.table[3, 3]).to eq Board::BOT_CELL
      board.free_cell(3, 3)
      expect(board.table[3, 3]).to eq Board::EMPTY_CELL
    end
    it '#update_cell', 'raise error' do
      expect { board.place_robot(10, 10) }.to raise_error Board::OutOfRangeError
    end

    it '#available?' do
      expect(board.available?(3, 3)).to eq true
      expect(board.available?(0, 0)).to eq true
      expect(board.available?(5, 5)).to eq false

      board.place_robot(3, 3)
      expect(board.available?(3, 3)).to eq false
    end
  end
end
