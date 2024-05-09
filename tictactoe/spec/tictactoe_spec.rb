#spec/tictactoe_spec.rb
require './lib/tictactoe.rb'

RSpec.describe PlayerModel do
  let(:player) { PlayerModel.new('Player 1', 'X') }

  it 'should correctly assign player attributes' do
    expect(player.name).to eq('Player 1')
    expect(player.symbol).to eq('X')
  end
end

RSpec.describe BoardModel do
  let(:board) { BoardModel.new }
  let(:player1) { board.player1 }
  let(:player2) { board.player2 }

  describe '#take_turn' do
    it 'allows a valid move' do
      expect(board.take_turn(0, 0)).to be true
      expect(board.grid[0][0]).to eq(player1.symbol)
    end

    it 'rejects an invalid move' do
      board.take_turn(0, 0)
      expect(board.take_turn(0, 0)).to be false
    end
  end

  describe '#valid_move?' do
    it 'returns true for a valid position' do
      expect(board.valid_move?(1, 1)).to be true
    end

    it 'returns false for a position already occupied' do
      board.take_turn(1, 1)
      expect(board.valid_move?(1, 1)).to be false
    end

    it 'returns false for out-of-bound positions' do
      expect(board.valid_move?(3, 3)).to be false
      expect(board.valid_move?(-1, 1)).to be false
    end
  end

  describe '#switch_player' do
    it 'switches the current player from player1 to player2' do
      board.switch_player
      expect(board.current_player).to eq(player2)
    end

    it 'switches back to player1' do
      board.switch_player
      board.switch_player
      expect(board.current_player).to eq(player1)
    end
  end

  describe '#check_win' do
    it 'returns true if a player wins via rows' do
      3.times { |col| board.grid[0][col] = player1.symbol }
      expect(board.check_win).to be true
    end

    it 'returns true if a player wins via columns' do
      3.times { |row| board.grid[row][0] = player1.symbol }
      expect(board.check_win).to be true
    end

    it 'returns true if a player wins via diagonal' do
      3.times { |i| board.grid[i][i] = player1.symbol }
      expect(board.check_win).to be true
    end

    it 'returns true if a player wins via reverse diagonal' do
      board.grid[0][2] = player1.symbol
      board.grid[1][1] = player1.symbol
      board.grid[2][0] = player1.symbol
      expect(board.check_win).to be true
    end

    it 'returns false if no win conditions are met' do
      expect(board.check_win).to be false
    end
  end

  describe '#game_ended?' do
    it 'returns true when all cells are filled without a winner' do
      board.grid = [
        %w[X O X],
        %w[O X O],
        %w[O X O]
      ]
      expect(board.game_ended?).to be true
    end

    it 'returns true if a player wins' do
      3.times { |col| board.grid[0][col] = player1.symbol }
      expect(board.game_ended?).to be true
    end

    it 'returns false if the game is still ongoing' do
      expect(board.game_ended?).to be false
    end
  end
end

RSpec.describe GameController do
  let(:game) { GameController.new }

  describe '#reset_game' do
    it 'resets the game by creating a new board' do
      game.instance_variable_get(:@model).take_turn(0, 0)
      game.reset_game
      expect(game.instance_variable_get(:@model).grid.flatten).to all(eq ' ')
    end
  end

  describe '#play_game' do
    it 'plays a full game without errors' do
      allow(game).to receive(:gets).and_return('1', '2', '3', '4', '5', '6', '7', '8', '9', 'n')
      expect { game.play_game }.to output(/Thank You for Playing!!/).to_stdout
    end
  end
end
