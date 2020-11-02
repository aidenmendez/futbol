require_relative './test_helper'

class GameTeamTest < Minitest::Test

  def setup
    # row = {
    #   game_id: "2012030111",
    #   team_id: "2",
    #   hoa: "away",
    #   result: "LOSS",
    #   settled_in: "REG",
    #   head_coach: "Jack Capuano",
    #   goals: "3",
    #   shots: "6",
    #   tackles: "36"
    #   }
    # parent = nil
    # @game_team = GameTeam.new(row, parent)
    locations = {
      games: './data/fixture_files/games.csv',
      teams: './data/fixture_files/teams.csv',
      game_teams: './data/fixture_files/game_teams.csv'
    }

    @stat_tracker = StatTracker.from_csv(locations)
    @game_team = stat_tracker.game_team
  end

  def test_it_exists_and_has_attributes
    assert_instance_of GameTeam, @game_team
    assert_equal "2012030111", @game_team.game_id
    assert_equal "2", @game_team.team_id
    assert_equal "away", @game_team.hoa
    assert_equal "LOSS", @game_team.result
    assert_equal "REG", @game_team.settled_in
    assert_equal "Jack Capuano", @game_team.head_coach
    assert_equal 3, @game_team.goals
    assert_equal 6, @game_team.shots
    assert_equal 36, @game_team.tackles
  end
end
