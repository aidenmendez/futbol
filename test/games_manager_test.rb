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

  def test_count_of_games_by_season
    hash = {
      "20122013" => 57,
      "20132014" => 6,
      "20142015" => 17,
      "20152016" => 16,
      "20162017" => 4
    }
    assert_equal hash, @games_manager.count_of_games_by_season
  end
end