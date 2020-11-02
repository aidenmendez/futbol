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
end