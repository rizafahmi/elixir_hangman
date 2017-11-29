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
  
  test "Recognize a good guess" do
    game = Game.new_game("wobbly")
    { game, _tally } = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end
  
  test "Won a game" do
    game = Game.new_game("wobbly")
    { game, _tally } = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "o")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "b")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "l")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "y")
    assert game.game_state == :won
    assert game.turns_left == 7
  end
  
  test "Recognize bad guess" do
    game = Game.new_game("wibble")
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end
  
  test "Recognize lost" do
    game = Game.new_game("wibble")
    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5
    { game, _tally } = Game.make_move(game, "c")
    assert game.game_state == :bad_guess
    assert game.turns_left == 4
    { game, _tally } = Game.make_move(game, "d")
    assert game.game_state == :bad_guess
    assert game.turns_left == 3
    { game, _tally } = Game.make_move(game, "z")
    assert game.game_state == :bad_guess
    assert game.turns_left == 2
    { game, _tally } = Game.make_move(game, "f")
    assert game.game_state == :bad_guess
    assert game.turns_left == 1
    { game, _tally } = Game.make_move(game, "g")
    assert game.game_state == :lost
  end
end
