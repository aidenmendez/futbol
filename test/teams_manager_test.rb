require_relative './test_helper'

class GamesManagerTest < Minitest::Test
  def setup
    location = './data/teams.csv'
    parent = nil
    @teams_manager = TeamsManager.get_data(location, parent)
  end
end
