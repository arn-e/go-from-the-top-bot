class Player

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end

end

class Computer < Player

  def initialize(name="Computer")
    @name = name
  end

  def pick_move
    rand(1..7)
  end

end