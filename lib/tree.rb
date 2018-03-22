require_relative 'node'

class Tree
  include Enumerable

  attr_accessor :root_node,
                :node_depth,
                :leaf_count

  def initialize(root_score = nil, root_name = nil)
    @root_node = Node.new(root_score, root_name)
    @node_depth = 0
    @leaf_count = 0
  end

  def insert(score, name)
    new_node = Node.new(score, name)
    if @root_node.score == nil
      @root_node = new_node
    else
      insert_new_node(new_node, @root_node)
    end
  end

  def insert_new_node(new_node, original_node)
    new_node.depth += 1
    if new_node.score < original_node.score
      return insert_new_node(new_node, original_node.left) unless original_node.left.nil?
      return original_node.left = new_node
    elsif new_node.score > original_node.score
      return insert_new_node(new_node, original_node.right) unless original_node.right.nil?
      return original_node.right = new_node
    end
  end


  def start_search(score)
    if @root_node.nil?
      return nil
    else
      search_nodes(score, @root_node)
    end
  end

  def search_nodes(score, node)
    # require 'pry'; binding.pry
    @node_depth += 1
    if node == nil
      return nil
    elsif score == node.score
      return node
    elsif score < node.score
      search_nodes(score, node.left)
    elsif score > node.score
      search_nodes(score, node.right)
    end
  end

  def include?(score)
    if start_search(score) == nil
      return nil
    else
      return true
    end
  end

  def depth_of(score)
    node = start_search(score)
    if node == nil
      return nil
    else
      node.depth
    end
  end

  def check_root_node_min
    node = @root_node
    if node.left.nil?
      return node
    else
      min_score(@root_node)
    end
  end

  def min_score(node)
    if node.left.nil?
      return node
    else
      min_score(node.left)
    end
  end

  def check_root_node_max
    node = @root_node
    if node.right.nil?
      return node
    else
      max_score(@root_node)
    end
  end

  def max_score(node)
    if node.right.nil?
      return node
    else
      max_score(node.right)
    end
  end

  def sort
    if @root_node == nil
      return nil
    else continue_sort(@root_node)
    end
  end

  def continue_sort(node)
    sorted_array_of_movies = []
    return [] unless node
    continue_sort(node.left) +
    (sorted_array_of_movies << {score: node.score, name: node.name, depth: node.depth}) +
    continue_sort(node.right)
  end

  def load_values
    item_array = []
    File.open('movies_copy.txt') do |file|
      file.each_line do |line|
        value = line.split(", ")
        item_array << {score: value[0].to_i, name: value[1].strip}
      end
    end
    sorted_array_of_movies = sort
    item_array.each do |entry|
      if sorted_array_of_movies.any? do |name| 
          name[:score] == entry[:score]
          end 
        item_array.delete(entry)
      else
        insert(entry[:score], entry[:name])
      end
    end
  end

  def health(depth)
    sorted_array_of_movies = sort
    total_nodes = sorted_array_of_movies.length
    health_array_of_nodes = sorted_array_of_movies.select { |hash| hash[:depth] == depth}
    large_health_array = health_array_of_nodes.map do |node|
      starting_node = start_search(node[:score])
      sorted_array = continue_sort(starting_node)
      amount_of_children = sorted_array.length
      [node[:score], (amount_of_children + 1), (((amount_of_children.to_f + 1)/total_nodes.to_f) * 100).to_i.floor ]
    end
    return large_health_array
  end

  def leaves(node = @root_node)
      return 0 if node.nil?
      if node.left.nil? && node.right.nil?
        # require 'pry'; binding.pry
        @leaf_count += 1 
      else
        # require 'pry'; binding.pry
        return leaves(node.left) + leaves(node.right)
      end
  end

    def return_leaves
      leaves
      p @leaf_count
    end

    def height
      sorted_array_of_movies = sort
      highest = sorted_array_of_movies.max_by { |node| node[:depth] }
      p highest[:depth]
    end

    def delete(score)
      node_delete = start_search(score)
      delete_node(node_delete)
    end


    def delete_node(node)
      node_to_delete = node
      require 'pry'; binding.pry
      if node_to_delete.left.nil? && node_to_delete.right.nil?
        node_to_delete = nil
      elsif node_to_delete.left != nil && node_to_delete.right == nil
        node_to_delete = node_to_delete.left
      elsif node_to_delete.left == nil && node_to_delete.right != nil
        node_to_delete = node_to_delete.right
      else
        temp_node = min_score(node_to_delete.right)
        node_to_delete = nil
        require 'pry'; binding.pry
        insert(temp_node.score, temp_node.name )
        delete_node(temp_node)
        print sort
        require 'pry'; binding.pry
      end
    end
end

# x = Tree.new
# x.load_values
# print x.sort
# # x.health(2)
# x.return_leaves
# x.height
# x.delete(55)
# p x.sort

# x.start_search(62)
# x.include?(55)
