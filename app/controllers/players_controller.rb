class PlayersController < ApplicationController
  def show
    if !(Game.count > 0)
      game = Game.create
      game.create_game
    end

    current_player = Player.where(id: params['id']).take
    other_player = Player.where.not(id: params['id']).take

    puts "current_player #{current_player}"

    @board1 = current_player.board.cells.as_json
    @board2 = other_player.board.cells.as_json

    respond_to do |format|
      format.html { render "show", :locals => { :otherPlayerId => other_player, :currentPlayerId => current_player } }
      format.json { render json: {"player": @board1, "opponent": @board2} }
    end
  end

  def update
  end
end
