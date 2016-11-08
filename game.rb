require './player'
require './question'
require './game_constants'
require './gamemaster'

class Game

  def initialize
    @gm = GameMaster.new
    @q = QuestionMaster.new
    @player1 = nil
    @player2 = nil
    @continue_game = true
    @turn = 1
  end

  def start_game
    @gm.speak(GameConstants::INTRO)
    set_player_names
    while(@continue_game == true)
      @gm.speak("-------NEW TURN------")
      @continue_game = get_question
    end
  end

  def set_player_names
    @gm.speak("Please Enter Your Name, Player 1 : ")
    name = @gm.prompt
    @player1 = Player.new(name)

    @gm.speak("Please Enter Your Name, Player 2 : ")
    name = @gm.prompt
    @player2 = Player.new(name)

    @gm.speak("your names are: #{@player1.name} and #{@player2.name}  is that correct? (y or n)")

    answer = @gm.prompt

    if answer == "y"
     @gm.speak("Great! let us begin!\n")
    elsif answer == "n"
      set_player_names
    else
     @gm.speak(   "please answer with 'y' or 'n' only")
      set_player_names
    end
  end

  def get_question
    player = nil
    if @turn == 1
      player = @player1
    elsif @turn == -1
      player = @player2
    end
    @gm.speak(player.name )
    question = @q.makeQuestion
    @gm.speak(question)

    is_answer_correct?(player)

  end

  def is_answer_correct?(player)
    answer = @gm.prompt.to_i
    if answer == @q.answer
      @gm.speak("Correct!")
      @turn = @turn * -1
      true
    else

      @turn = @turn * -1
      player.lives -= 1
      @gm.speak("\nIncorrect! \n\t-1 life for you #{player.name}, you have #{player.lives} lives left..\n")
      check_player_life(player)
    end
  end

  def check_player_life(player)
    player.lives > 0? true : game_end
    # puts "yes"
  end

  def game_end
    winner = get_winner
    @gm.speak("\n #{winner.name} wins! with a score of #{winner.lives}/3")
    @gm.speak("-----------GAME OVER------------\n goodbye!")
  end
  def get_winner
    @player1.lives > @player2.lives ? @player1 : @player2
  end
end