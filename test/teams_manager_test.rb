require_relative './test_helper'

class TeamsManagerTest < Minitest::Test
  def setup
    locations = {
      games: './data/games.csv',
      teams: './data/teams.csv',
      game_teams: './data/game_teams.csv'
    }
    @controller = StatTracker.from_csv(locations)
    @teams_manager = @controller.teams_manager
  end

  def test_it_exists	
    assert_instance_of TeamsManager, @teams_manager
  end

  def test_can_retrieve_team_info
    expected = {"team_id"=>"6", "franchise_id"=>"6", "team_name"=>"FC Dallas", "abbreviation"=>"DAL", "link"=>"/api/v1/teams/6"}
    assert_equal expected, @teams_manager.team_info("6")
  end
end