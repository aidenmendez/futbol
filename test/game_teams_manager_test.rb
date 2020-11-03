require_relative './test_helper'

class GameTeamsManagerTest < Minitest::Test
  def setup
    locations = {
      games: './data/games.csv',
      teams: './data/teams.csv',
      game_teams: './data/game_teams.csv'
    }
    @controller = StatTracker.from_csv(locations)
    @game_teams_manager = @controller.game_teams_manager
  end

  def test_it_exists	
    assert_instance_of GameTeamsManager, @game_teams_manager
  end

  def test_winningest_coach
    assert_equal "Alain Vigneault", @game_teams_manager.winningest_coach("20142015")
  end

  def test_coaches_by_season
    coach_hash = {
      "Joel Quenneville" => {:games => 0, :wins => 0},
      "Jon Cooper" => {:games => 0, :wins => 0}
    } 
    season_game_teams = []
    parent = nil
    game_1 = GameTeam.new({ game_id: "2014030411", goals: 2, head_coach: "Joel Quenneville", hoa: "away", result: "WIN", settled_in: "REG", shots: 5, tackles: 21, team_id: "16" }, parent)
    game_2 = GameTeam.new({ game_id: "2014030411", goals: 1, head_coach: "Jon Cooper", hoa: "home", result: "LOSS", settled_in: "REG", shots: 5, tackles: 29, team_id: "14" }, parent)
    season_game_teams = [game_1, game_2]

    assert_equal coach_hash, @game_teams_manager.coaches_by_season("20152016", season_game_teams)
  end

  def test_game_team_by_season_zzz
    parent = nil
    game_1 = GameTeam.new({ game_id: "2014030411", goals: 2, head_coach: "Joel Quenneville", hoa: "away", result: "WIN", settled_in: "REG", shots: 5, tackles: 21, team_id: "16" }, parent)
    game_2 = GameTeam.new({ game_id: "2014030411", goals: 1, head_coach: "Jon Cooper", hoa: "home", result: "LOSS", settled_in: "REG", shots: 5, tackles: 29, team_id: "14" }, parent)
    game_3 = GameTeam.new({ game_id: "2014034363", goals: 1, head_coach: "Jon Cooper", hoa: "home", result: "LOSS", settled_in: "REG", shots: 5, tackles: 29, team_id: "14" }, parent)
    season_game_teams = [game_1.game_id, game_2.game_id]

    @game_teams_manager.expects(:game_ids_by_season).returns(season_game_teams)

    assert_equal [game_1, game_2], @game_teams_manager.game_team_by_season("20142015")
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

  def test_total_games
    assert_equal 7441, @game_teams_manager.total_games
  end

  def test_percentage_home_wins
    # Still not sure of what assertion should be, but running and returning
    assert_equal 0.60, @game_teams_manager.percentage_home_wins
  end

  def test_percentage_visitor_wins
    # Still not sure of what assertion should be, but running and returning
    assert_equal 0.60, @game_teams_manager.percentage_visitor_wins
  end

  def test_percentage_ties
    # Still not sure of what assertion should be, but running and returning
    assert_equal 0.60, @game_teams_manager.percentage_ties
  end

  def test_most_accurate_team
    assert_equal "New York City FC", @game_teams_manager.most_accurate_team("20152016")
  end

  def test_most_tackles
    assert_equal "FC Cincinnati", @game_teams_manager.most_tackles("20132014")  
  end

  def test_fewest_tackles
    assert_equal "Atlanta United", @game_teams_manager.fewest_tackles("20132014")
  end

  def test_can_retrieve_average_win_percetange_for_all_games_for_a_team
    assert_equal 1.00, @game_teams_manager.average_win_percentage("6")
  end

  def test_can_retrieve_highest_number_of_goals_from_single_game
    assert_equal 4, @game_teams_manager.most_goals_scored("6")
  end

  def test_can_retrieve_fewest_number_of_goals_from_single_game
    assert_equal 0, @game_teams_manager.fewest_goals_scored("6")
  end
end