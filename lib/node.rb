class Node

attr_accessor :depth,
              :score,
              :name,
              :left,
              :right
  def initialize(score, name)
    @score = score
    @name = name
    @left = nil
    @right = nil
    @depth = 0
  end
end
