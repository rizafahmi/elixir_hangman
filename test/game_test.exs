defmodule GameTest do
  use ExUnit.Case
  alias Hangman.Game
  
  test "new game returns struct" do
    game = Game.new_game()
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end
  
  test "all letters should be lower case" do
    game = Game.new_game()
    caps = Enum.filter(game.letters, fn letter -> Regex.match?(~r/[A-Z]/, letter) end)
    assert length(caps) < 1
  end
  
  test "State doesnt change for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      { ^game, _ } = Game.make_move(game, "x")
    end
  end
  
  test "First occurence of letter is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "Second occurence of letter is already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end
end
