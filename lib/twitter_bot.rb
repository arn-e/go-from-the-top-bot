require 'tweetstream'
require 'twitter'
require 'pp'
require './board'
require './game'
require './interface'

class TwitterResponder

  def initialize
    @in_progress = false
    @opponent = nil
    @twitter_hash_tag = "#abc_c5"

    Twitter.configure do |config|
      config.consumer_key = '14MRPh1vhw5rlHZOXkiw4g'
      config.consumer_secret = "7W1gNUwWnQH0B88KpHMCPMWlnRvtEyC7IIFPPWwPNY"
      config.oauth_token = "921637273-3b2UEyjt59Cnu6dWfBY1zQjkJ92Qv2OxI4HpWgvd"
      config.oauth_token_secret = "dcbIZbDBHKnnm5nRtXnsTtwk3bS8S0O7WVyYxLbPlU"
    end

    TweetStream.configure do |config|
      config.consumer_key = '14MRPh1vhw5rlHZOXkiw4g'
      config.consumer_secret = "7W1gNUwWnQH0B88KpHMCPMWlnRvtEyC7IIFPPWwPNY"
      config.oauth_token = "921637273-3b2UEyjt59Cnu6dWfBY1zQjkJ92Qv2OxI4HpWgvd"
      config.oauth_token_secret = "dcbIZbDBHKnnm5nRtXnsTtwk3bS8S0O7WVyYxLbPlU"
      config.auth_method        = :oauth
    end

    @stream = TweetStream::Client.new
    monitor_stream
  end

  def initialize_new_game(opponent,local_player = "Computer1")
    @new_game, @in_progress = Interface.new(opponent,local_player), true
  end

  def monitor_stream
    @stream.track(@twitter_hash_tag) {|status| send_reply(status.user[:screen_name]) if status.text =~ /Who wants to get demolished/}
  end

  def generate_hash
    (0...3).map{65.+(rand(26)).chr}.join
  end

  def send_reply(reply_to_user)
    Twitter.update("@#{reply_to_user} Game on! #{@twitter_hash_tag} #{generate_hash}")
    set_opponent(reply_to_user)
    wait_for_response
  end

  def set_opponent(opponent)
    @opponent = opponent
  end

  def send_move(tweet_sender)
    Twitter.update("@#{tweet_sender} #{board_to_string} #{generate_hash} #{@twitter_hash_tag}")
  end

  def wait_for_response
    @stream.track(@twitter_hash_tag) do |status|  
      tweet_recipient, tweet_board_string = parse_response(status.text) 
      tweet_sender = status.user[:screen_name]
      if tweet_recipient.gsub('@','') == Twitter.user[:screen_name] && tweet_sender == @opponent
        initialize_new_game(tweet_sender) if @in_progress == false
        update_game_information(tweet_board_string, tweet_sender)
      end
    end
  end

  def update_game_information(tweet_board_string, tweet_sender)
    @new_game.player_turn(interpret_move(tweet_board_string) + 1)
    check_victory_conditions
    execute_move
    send_move(tweet_sender)
    wait_for_response
  end

  def check_victory_conditions
    if @new_game.game.victory? || @new_game.game.draw?
      twitter_announce_winner
    end
  end

  def twitter_announce_winner
    if @game.draw?
      (Twitter.update("@#{@opponent} : Draw game, play again?"))
    elsif game.  
      (Twitter.update("@#{@opponent} : Congratulations!  #{@new_game.game.turn} is the winner!")
    end
    Kernel::exit
  end

  def execute_move
    @new_game.game.switch_turn
    @new_game.player_turn(@new_game.computer.pick_move)
    check_victory_conditions
    @new_game.game.switch_turn
  end

  def board_to_string
    @new_game.game.board.to_twitter_string
  end

  def parse_response(text)
    [text.split(' ')[0], text.split(' ')[1]]
  end

  def convert_board(board, converted_twitter_board = [])
    board[1..-2].split('|').each{|i| converted_twitter_board << i.split('')}
    converted_twitter_board.each {|i| i.each {|j| j = " " if j == "."}}
  end

  def interpret_move(new_board, current_board = @new_game.game.board.board)
    convert_board(new_board).each_with_index {|i, row| i.each_with_index { |j, column| (return column) if (j != current_board[row][column] && current_board[row][column] == ".")}}
    wait_for_response
  end

end

twit_responder = TwitterResponder.new
