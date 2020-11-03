require_relative './test_helper'

class GamesManagerTest < Minitest::Test
  def setup
    location = './data/teams.csv'
    parent = nil
    @teams_manager = TeamsManager.get_data(location, parent)
  end

  def test_it_exists_and_has_attributes
    assert_instance_of TeamsManager, @teams_manager
    assert_equal 32, @teams_manager.teams.length
    assert_nil @teams_manager.parent
  end

  def test_count_of_teams
    assert_equal 32, @teams_manager.count_of_teams
  end
end
