require_relative "./test_helper"

class GamesManagerTest < Minitest::Test
  def setup
    locations = {
      games: "./data/games.csv",
      teams: "./data/teams.csv",
      game_teams: "./data/game_teams.csv"
    }
    @controller = StatTracker.from_csv(locations)
    @games_manager = @controller.games_manager
  end

  def test_it_exists_and_has_attributes
    assert_instance_of GamesManager, @games_manager
    assert_equal 7441, @games_manager.games.length
  end

  def test_highest_total_score
    assert_equal 11, @games_manager.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 0, @games_manager.lowest_total_score
  end

  def test_count_of_games_by_season
    hash = {"20122013" => 806, "20162017" => 1317, "20142015" => 1319, "20152016" => 1321, "20132014" => 1323, "20172018" => 1355}
    assert_equal hash, @games_manager.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 4.22, @games_manager.average_goals_per_game
  end

  def test_average_goals_by_season
    hash = {"20122013" => 4.12, "20162017" => 4.23, "20142015" => 4.14, "20152016" => 4.16, "20132014" => 4.19, "20172018" => 4.44}
    assert_equal hash, @games_manager.average_goals_by_season
  end

  def test_best_best_season
    assert_equal "20132014", @games_manager.best_season("6")
  end

  def test_retrieve_best_season_by_team
    assert_equal "20132014", @games_manager.best_season("6")
  end

  def test_retrieve_worst_season_by_team
    assert_equal "20142015", @games_manager.worst_season("6")
  end

  def test_can_check_favorite_opponent
    assert_equal "Columbus Crew SC", @games_manager.favorite_opponent("6")
  end

  def test_can_check_rival
    assert_equal "Real Salt Lake", @games_manager.rival("6")
  end

  def test_highest_scoring_visitor
    assert_equal "FC Dallas", @games_manager.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "Reign FC", @games_manager.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    assert_equal "San Jose Earthquakes", @games_manager.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    assert_equal "Utah Royals FC", @games_manager.lowest_scoring_home_team
  end

  def test_calc_percentage
    assert_equal 0.33, @games_manager.calc_percentage(1, 3)
  end
end
