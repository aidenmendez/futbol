require './test/test_helper'

class StatTrackerTest < MiniTest::Test

  def setup
    locations = {
      games: './data/fixture_files/games.csv',
      teams: './data/fixture_files/teams.csv',
      game_teams: './data/fixture_files/game_teams.csv'
    }
    @stat_tracker = StatTracker.from_csv(locations)
  end

# Game Statistics Methods
  def test_highest_total_score
    assert_equal 5, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_percentage_home_wins
    assert_equal 60.00, @stat_tracker.percentage_home_wins
  end
end
