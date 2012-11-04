require 'tweetstream'
require 'twitter'
require 'pp'
require 'board'
require 'game'
require 'interface'

class TwitterResponder

  def initialize
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
  end

  def monitor_stream
    @stream.track('#dbc_c4') do |status|
      send_reply(status.user[:screen_name]) if status.text =~ /Who wants to get demolished\?/
    end
  end

  def send_reply(reply_to_user)
    Twitter.update("@#{reply_to_user} Game on! #dbc_c4")
    wait_for_response
  end

  def wait_for_response
    @stream.userstream do |status|
      parse_response(status.user[:screen_name],status.text)
    end
  end

  def parse_response(from_user, text)
    tweet_recipient, board = text.split(' ')[0], text.split(' ')[1]
    raise "huh" if board.length != 49
    initialize_game(from_user,"Computer1",board)
  end

  def initialize_game(from_user,local_user)
    new_game = Interface.new(from_user,local_user)
  end

  def convert_board(board)
    local_board = Board.new
    p board
  end

  def update_board(game)
    game.board # set game board to be equal to the string
  end

  def set_player_state
    #update turn information with the info from the game
  end


end

twit_responder = TwitterResponder.new
twit_responder.convert_board('|.......|.......|.......|....O..|..XOX..|..OXXO.|')
# twit_responder.wait_for_response
