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

  def test_game_team_by_season
    parent = mock("Parent")
    game_1 = GameTeam.new({ game_id: "2014030411", goals: 2, head_coach: "Joel Quenneville", hoa: "away", result: "WIN", settled_in: "REG", shots: 5, tackles: 21, team_id: "16" }, parent)
    game_2 = GameTeam.new({ game_id: "2014030411", goals: 1, head_coach: "Jon Cooper", hoa: "home", result: "LOSS", settled_in: "REG", shots: 5, tackles: 29, team_id: "14" }, parent)
    game_3 = GameTeam.new({ game_id: "2014034363", goals: 1, head_coach: "Jon Cooper", hoa: "home", result: "LOSS", settled_in: "REG", shots: 5, tackles: 29, team_id: "14" }, parent)
    season_game_teams = [game_1.game_id, game_2.game_id]
    @game_teams_manager.stubs(:game_teams).returns([game_1, game_2, game_3])
    @game_teams_manager.expects(:game_ids_by_season).returns(season_game_teams)

    assert_equal [game_1, game_2], @game_teams_manager.game_team_by_season("20142015")
  end

  def test_game_ids_by_season
    parent = nil
    games_manager = @controller.games_manager
    game1 = Game.new({game_id: "2012030221", season: "20122013",type: "Postseason", date_time: "5/16/13", away_team_id: "3", home_team_id: "6", away_goals: 2, home_goals: 3, venue: "Toyota Stadium", venue_link: "/api/v1/venues/null"}, parent)
    game2 = Game.new({game_id: "2012030223", season: "20122013",type: "Postseason", date_time: "5/16/13", away_team_id: "3", home_team_id: "6", away_goals: 2, home_goals: 3, venue: "Toyota Stadium", venue_link: "/api/v1/venues/null"}, parent)
    game3 = Game.new({game_id: "2012030225", season: "20122011",type: "Postseason", date_time: "5/16/13", away_team_id: "3", home_team_id: "6", away_goals: 2, home_goals: 3, venue: "Toyota Stadium", venue_link: "/api/v1/venues/null"}, parent)
    games_objects = [game1, game2, game3]
    games_manager.stubs(:games).returns(games_objects)

    assert_equal [game1.game_id, game2.game_id], @game_teams_manager.game_ids_by_season("20122013")
  end

  def test_get_stats
    parent = mock("parent")
    game_1 = GameTeam.new({ game_id: "2014030411", goals: 2, head_coach: "Joel Quenneville", hoa: "away", result: "WIN", settled_in: "REG", shots: 5, tackles: 21, team_id: "16" }, parent)
    game_2 = GameTeam.new({ game_id: "2014030411", goals: 1, head_coach: "Jon Cooper", hoa: "home", result: "LOSS", settled_in: "REG", shots: 5, tackles: 29, team_id: "14" }, parent)
    game_3 = GameTeam.new({ game_id: "2014034363", goals: 1, head_coach: "Jon Cooper", hoa: "home", result: "LOSS", settled_in: "REG", shots: 5, tackles: 29, team_id: "14" }, parent)
    season_game_teams = [game_1, game_2, game_3]
    season = mock("season")
    coaches = {"Joel Quenneville" => {games: 0, wins: 0},
              "Jon Cooper" => {games: 0, wins: 0}
              }
    
    expected = {"Joel Quenneville" => {games: 1, wins: 1},
                "Jon Cooper" => {games: 2, wins: 0}
                }
    assert_equal expected, @game_teams_manager.get_stats(coaches, season, season_game_teams)
  end

  def test_calc_coach_percentage
    coach_stats = {"Harry Potter" => {wins: 5, games: 10},
                  "Hairy Potter" => {wins: 7, games: 10} }
    
    expected = {"Harry Potter" => 0.5, "Hairy Potter" => 0.7}
    assert_equal expected, @game_teams_manager.calc_coach_percentage(coach_stats)
  end

  def test_calc_percentage
    assert_equal 0.33, @game_teams_manager.calc_percentage(1, 3)
  end

  def test_worst_coach
    assert_equal "Ted Nolan", @game_teams_manager.worst_coach("20142015")
  end

  def test_total_games
    assert_equal 7441, @game_teams_manager.total_games
  end

  def test_percentage_home_wins
    # Still not sure of what assertion should be, but running and returning
    assert_equal 0.44, @game_teams_manager.percentage_home_wins
  end

  def test_percentage_visitor_wins
    # Still not sure of what assertion should be, but running and returning
    assert_equal 0.36, @game_teams_manager.percentage_visitor_wins
  end

  def test_percentage_ties
    # Still not sure of what assertion should be, but running and returning
    assert_equal 0.2, @game_teams_manager.percentage_ties
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

  def test_can_retrieve_average_win_percentage_for_all_games_for_a_team
    assert_equal 0.49, @game_teams_manager.average_win_percentage("6")
  end

  def test_can_retrieve_highest_number_of_goals_from_single_game
    assert_equal 6, @game_teams_manager.most_goals_scored("6")
  end

  def test_can_retrieve_fewest_number_of_goals_from_single_game
    assert_equal 0, @game_teams_manager.fewest_goals_scored("6")
  end
#check assertion-- may be fixture file assertion
  def test_team_with_best_offense
    assert_equal "Reign FC", @game_teams_manager.best_offense
  end

  def test_team_with_worst_offense
    assert_equal "Utah Royals FC", @game_teams_manager.worst_offense
  end
end