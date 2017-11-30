defmodule Hangman do
  alias Hangman.Game

  def hello do
    Dictionary.random_word()
  end
  defdelegate new_game(), to: Game
  defdelegate tally(game), to: Game
  
  def make_move(game, guess) do
    game = Game.make_move(game, guess)
    { game, tally(game) }
  end
end
