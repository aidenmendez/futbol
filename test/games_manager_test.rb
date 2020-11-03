require_relative './test_helper'

class GamesManagerTest < Minitest::Test
  def setup
    locations = {
      games: './data/games.csv',
      teams: './data/teams.csv',
      game_teams: './data/game_teams.csv'
    }
    @controller = StatTracker.from_csv(locations)
    @games_manager = @controller.games_manager
  end

  def test_it_exists_and_has_attributes
    assert_instance_of GamesManager, @games_manager
    assert_equal 7441, @games_manager.games.length
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

  def test_average_goals_per_game
    assert_equal 3.95, @games_manager.average_goals_per_game
  end

  def test_average_goals_by_season
    hash = {
      "20122013" => 3.86,
      "20132014" => 4.33,
      "20142015" => 4.00,
      "20152016" => 3.88,
      "20162017" => 4.75
    }

    assert_equal hash, @games_manager.average_goals_by_season
  end

  def test_best_best_season
    assert_equal "x", @games_manager.best_season("6")
  end

  def test_retrieve_best_season_by_team
    assert_equal "20122013", @games_manager.best_season("6")
  end
  
  def test_retrieve_worst_season_by_team
    assert_equal "20122013", @games_manager.worst_season("6")
  end

  def test_can_check_favorite_opponent
    assert_equal "Houston Dynamo", @games_manager.favorite_opponent("6")
  end

  def test_can_check_rival
    assert_equal "Houston Dynamo", @games_manager.rival("6")
  end
end
  def test_highest_scoring_visitor
    assert_equal "FC Dallas", @games_manager.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "New York City FC", @games_manager.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    assert_equal "Seattle Sounders FC", @games_manager.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    assert_equal "Chicago Fire", @games_manager.lowest_scoring_home_team
  end
end
