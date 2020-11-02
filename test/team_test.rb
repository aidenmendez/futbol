require_relative './test_helper'

class TeamTest < Minitest::Test
  def setup
    row = {
      team_id: "1",
      franchiseId: "16",
      teamName: "Atlanta United",
      abbreviation: "ATL",
      stadium: "Mercedes-Benz Stadium",
      link: "/api/v1/teams/1"
    }
    parent = nil
    @team1 = Team.new(row, parent)
  end

  def test_it_exists_has_attributes
    assert_instance_of Team, @team1
    assert_equal "1", @team1.team_id
    assert_equal "16", @team1.franchise_id
    assert_equal "Atlanta United", @team1.team_name
    assert_equal "ATL", @team1.abbreviation
    assert_equal "Mercedes-Benz Stadium", @team1.stadium
    assert_equal "/api/v1/teams/1", @team1.link
  end
end