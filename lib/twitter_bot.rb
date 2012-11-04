require 'tweetstream'
require 'twitter'
require 'pp'
require './board'
require './game'
require './interface'

class TwitterResponder

  def initialize
    @in_progress = false

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
    puts "debug : initialize new game triggered"
    @new_game, @in_progress = Interface.new(opponent,local_player), true
  end

  def monitor_stream
    puts "debug : monitor stream triggered"
    @stream.track('#abc_c4') {|status| send_reply(status.user[:screen_name]) if status.text =~ /Who wants to get demolished\?/}
  end

  def generate_hash
    (0...3).map{65.+(rand(26)).chr}.join
  end

  def send_reply(reply_to_user)
    puts "debug : send reply triggered"
    Twitter.update("@#{reply_to_user} Game on! #abc_c4 #{generate_hash}")
    wait_for_response
  end

  def send_move(tweet_sender)
    puts "debug : send move triggered"
    Twitter.update("@#{tweet_sender} #{board_to_string} #{generate_hash}")
  end

  def wait_for_response
    puts "debug : wait_for_response triggered"
    @stream.userstream do |status| 
      tweet_recipient, tweet_board_string = parse_response(status.text) 
      tweet_sender = status.user[:screen_name]
      p "debug : tweet_recipient    : #{tweet_recipient}"
      p "debug : tweet board string : #{tweet_board_string}"
      p "debug : tweet sender       : #{tweet_sender}"
      p "debug : in progress        : #{@in_progress}"
      initialize_new_game(tweet_sender) if @in_progress == false
      update_game_information(tweet_board_string, tweet_sender)
    end
  end

  def update_game_information(tweet_board_string, tweet_sender)
    puts "debug : update_game_information triggered"
    puts "debug : tweet board string : #{tweet_board_string}"
    puts "debug : interpreted move : #{interpret_move(tweet_board_string)}"
    @new_game.player_turn(interpret_move(tweet_board_string))
    execute_move
    puts "stuff"
    send_move(tweet_sender)
  end

  def execute_move
    puts "debug : execute move triggered"
    @new_game.game.switch_turn
    @new_game.player_turn
    puts "debug : cycle completed"
  end

  def board_to_string
    puts "debug : board to string triggered"
    @new_game.game.board.board.to_twitter_string
    p "hummmm"
  end

  def parse_response(text)
    puts "debug : parse text triggered"
    [text.split(' ')[0], text.split(' ')[1]]
  end

  def convert_board(board, converted_twitter_board = [])
    puts "debug : convert_board triggered"
    board[1..-2].split('|').each{|i| converted_twitter_board << i.split('')}
    converted_twitter_board.each {|i| i.each {|j| j = " " if j == "."}}
  end

  def interpret_move(new_board, current_board = @new_game.game.board.board)
    puts "debug : interpret move triggered"
    puts "debug : new board     : #{convert_board(new_board)}"
    puts "debug : current board : #{current_board}"
    convert_board(new_board).each_with_index {|i, idx| i.each_with_index { |j, jdx| (return idx) if j != current_board[idx][jdx]}}
    puts "debug : something"
    wait_for_response #if no move made
  end

  def update_board #for debug purposes only
    puts "debug : update_board triggered"
    @new_game.game.board = [[".", ".", ".", ".", ".", ".", "."], [".", ".", ".", ".", ".", ".", "."], [".", ".", ".", ".", ".", ".", "."], [".", ".", ".", ".", "O", ".", "."], [".", ".", "X", "O", "X", ".", "."], [".", ".", "O", "X", "X", "O", "."]]
  end

end

twit_responder = TwitterResponder.new
# p twit_responder.interpret_move('|.......|.......|.......|.......|.......|..O....|')

# p twit_responder.parse_response('@dbcconnectfour |.......|.......|.......|.......|.......|..O....| #fkeh')
