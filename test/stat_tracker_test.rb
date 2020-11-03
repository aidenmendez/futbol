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

# League Statistics Methods

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
