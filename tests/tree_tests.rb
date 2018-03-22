require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/tree.rb'
require_relative '../lib/node.rb'

class TreeTests < Minitest::Test

    def setup
        @t = Tree.new
    end

    def test_does_it_exist
        assert_instance_of Tree, @t
    end

    def test_does_it_insert
        @t.insert(55, "New")
        assert_equal [@t.root_node.score, @t.root_node.name], [55, "New"]
    end

    def test_does_it_search_correctly
        @t.insert(55, "New")
        @t.insert(65, "Newer")
        @t.insert(75, "Newest")
        node = @t.start_search(65)
        assert_equal [node.score, node.name], [65, "Newer"]
    end

    def test_can_it_tell_if_a_node_is_in_the_tree
        @t.insert(55, "New")
        @t.insert(65, "Newer")
        @t.insert(75, "Newest")
        assert @t.include?(65)
    end

    def test_does_it_give_the_correct_depth
        @t.insert(55, "New")
        @t.insert(65, "Newer")
        @t.insert(75, "Newest")
        assert_equal 2, @t.depth_of(75)
    end

    def test_does_it_find_the_min
        @t.insert(55, "New")
        @t.insert(65, "Newer")
        @t.insert(75, "Newest")
        node = @t.check_root_node_min
        assert_equal 55, node.score
    end

    def test_does_it_find_the_max
        @t.insert(55, "New")
        @t.insert(65, "Newer")
        @t.insert(75, "Newest")
        node = @t.check_root_node_max
        assert_equal 75, node.score
    end

    def does_it_sort_correctly
        @t.insert(55, "New")
        @t.insert(65, "Newer")
        @t.insert(75, "Newest")
        sorted_nodes = @t.sort
        assert_equal sorted_nodes[0], [{score: 55, name: "New", depth: 0}]
    end

    def test_can_it_load_values

    end

    def test_it_gives_the_right_health
        @t.insert(55, "New")
        @t.insert(65, "Newer")
        @t.insert(75, "Newest")
        health_array = @t.health(1)
        assert_equal = [65, 2, 33]
    end

    def test_it_can_find_leaves
        @t.insert(55, "New")
        @t.insert(65, "Newer")
        @t.insert(75, "Newest")
        assert_equal 1, @t.return_leaves
    end

    def test_it_can_find_correct_height
        @t.insert(55, "New")
        @t.insert(65, "Newer")
        @t.insert(75, "Newest")
        assert_equal @t.height, 2
    end

end

