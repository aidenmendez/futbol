require_relative './test_helper'

class GameTeamsManagerTest < Minitest::Test
  def setup
    locations = {
      games: './data/games.csv',
      teams: './data/teams.csv',
      game_teams: './data/game_teams.csv'
    }
    controller = StatTracker.from_csv(locations)
    @game_teams_manager = controller.game_teams_manager
  end

  def test_it_exists	
    assert_instance_of GameTeamsManager, @game_teams_manager
  end

  def test_winningest_coach
    assert_equal "Alain Vigneault", @game_teams_manager.winningest_coach("20142015")
  end

  def test_coaches_by_season
    coach_hash = {:games => 0, :wins => 0}

    all_coaches = @game_teams_manager.coaches_by_season("20152016")

    assert_equal coach_hash, all_coaches["Jack Capuano"]
  end

  def test_game_team_by_season

  end

  def test_game_ids_by_season

  end

  def test_get_stats

  end

  def test_calc_coach_percentage

  end

  def test_calc_percentage

  end

  def test_worst_coach
    assert_equal "Ted Nolan", @game_teams_manager.worst_coach("20142015")
  end
end