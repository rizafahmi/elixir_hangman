defmodule Hangman do
  alias Hangman.Game

  def hello do
    Dictionary.random_word()
  end

  defdelegate new_game(), to: Game
end
