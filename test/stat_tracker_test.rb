require_relative './test_helper'
require 'csv'

class StatTrackerTest < MiniTest::Test

  def setup
    locations = {
      games: './data/games.csv',
      teams: './data/teams.csv',
      game_teams: './data/game_teams.csv'
    }
    @stat_tracker = StatTracker.from_csv(locations)
  end

# Game Statistics Methods
  def test_highest_total_score
    assert_equal 11, @stat_tracker.highest_total_score
  end

  
  def test_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end
  
  def test_percentage_home_wins
    assert_equal 59.85, @stat_tracker.percentage_home_wins
  end
  
  def test_percentage_visitor_wins
    assert_equal 36.5, @stat_tracker.percentage_visitor_wins
  end
  
  def test_calc_percentage
    assert_equal 40.00, @stat_tracker.calc_percentage(2, 5)
  end
  
  def test_percentage_ties
    assert_equal 3.65, @stat_tracker.percentage_ties
  end
  
  def test_count_of_games_by_season
    hash = {
      "20122013" => 57,
      "20132014" => 6,
      "20142015" => 17,
      "20152016" => 16,
      "20162017" => 4
    }
    assert_equal hash, @stat_tracker.count_of_games_by_season
  end
  
  def test_average_goals_per_game
    avg = 3.95
    
    assert_equal avg, @stat_tracker.average_goals_per_game
  end
  
  def test_average_goals_by_season
    hash = {
      "20122013" => 3.86,
      "20132014" => 4.33,
      "20142015" => 4.00,
      "20152016" => 3.88,
      "20162017" => 4.75
    }
    
    assert_equal hash, @stat_tracker.average_goals_by_season
  end

# League Statistics Methods
  def test_count_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end
  
  # Need more data in fixture file for testing
  def test_team_with_best_offense
    assert_equal "New York City FC", @stat_tracker.best_offense
  end
  
  def test_team_with_worst_offense
    assert_equal "DC United", @stat_tracker.worst_offense
  end
  
  def test_highest_scoring_visitor
    assert_equal "FC Dallas", @stat_tracker.highest_scoring_visitor
  end
  
  # Need more data in fixture file for testing
  def test_highest_scoring_home_team
    assert_equal "New York City FC", @stat_tracker.highest_scoring_home_team
  end
  
  # Need more data in fixture file for testing
  def test_lowest_scoring_visitor
    assert_equal "Seattle Sounders FC", @stat_tracker.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    assert_equal "Chicago Fire", @stat_tracker.lowest_scoring_home_team
  end

  def test_winningest_coach
    assert_equal "Dan Bylsma", @stat_tracker.winningest_coach(20152016)
  end
  
  def test_worst_coach
    assert_equal "John Tortorella", @stat_tracker.worst_coach(20152016)
  end
  
  def test_most_accurate_team
    assert_equal "Sporting Kansas City", @stat_tracker.most_accurate_team(20152016)
  end
  
  def test_least_accurate_team
    assert_equal "Chicago Fire", @stat_tracker.least_accurate_team(20152016)
  end
  
  def test_most_tackles
    assert_equal "FC Cincinnati", @stat_tracker.most_tackles(20152016)
  end
  
  def test_fewest_tackles
    assert_equal "Sporting Kansas City", @stat_tracker.fewest_tackles(20152016)
  end
  
  #below assertions are not using fixture files
  #team statistics
  def test_can_retrieve_team_info
    expected = {"team_id"=>"6", "franchise_id"=>"6", "team_name"=>"FC Dallas", "abbreviation"=>"DAL", "link"=>"/api/v1/teams/6"}
    assert_equal expected, @stat_tracker.team_info("6")
  end
  
  def test_retrieve_best_season_by_team
    assert_equal "20122013", @stat_tracker.best_season("6")
  end
  
  def test_retrieve_worst_season_by_team
    assert_equal "20122013", @stat_tracker.worst_season("6")
  end
  
  def test_can_retrieve_average_win_percetange_for_all_games_for_a_team
    assert_equal 1.00, @stat_tracker.average_win_percentage("6")
  end
  
  def test_can_retrieve_highest_number_of_goals_from_single_game
    assert_equal 4, @stat_tracker.most_goals_scored("6")
  end
  
  def test_can_retrieve_fewest_number_of_goals_from_single_game
    assert_equal 0, @stat_tracker.fewest_goals_scored("6")
  end
  
  def test_can_check_favorite_opponent
    assert_equal "Houston Dynamo", @stat_tracker.favorite_opponent("6")
  end
  
  def test_can_check_rival
    assert_equal "Houston Dynamo", @stat_tracker.rival("6")
  end
end