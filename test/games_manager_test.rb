require_relative './test_helper'

class GamesManagerTest < Minitest::Test
  def setup
    location = './data/fixture_files/games.csv'
    parent = nil
    @games_manager = GamesManager.get_data(location, parent)
  end

  def test_it_exists_and_has_attributes	
    assert_instance_of GamesManager, @games_manager 
    assert_equal 100, @games_manager.games.length
    assert_nil @games_manager.parent
  end

  def test_highest_total_score
    assert_equal 8, @games_manager.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 1, @games_manager.lowest_total_score
  end

  def test_percentage_home_wins
    assert_equal 59.85, @games_manager.percentage_home_wins
  end
end