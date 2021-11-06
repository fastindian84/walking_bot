require 'spec_helper'

describe Board do
  describe 'validations' do
    it 'raise an excpetion with invalid params' do
      expect { Board.new(rows: '0', columns: 1) }.to raise_error Board::BoardError
      expect { Board.new(rows: '1', columns: 0) }.to raise_error Board::BoardError
      expect { Board.new(rows: '010', columns: 1) }.to_not raise_error
    end
  end

  describe '#place_bot' do
    it 'puts bot under certain position' do
      bot = MiniBot.new('NORTH')
      bord = Board.new(rows: 10, columns: 5)

      bord.place_bot(0, 0, bot)
      expect(bord.bot?).to be_truthy
    end
  end
end
