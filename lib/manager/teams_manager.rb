require_relative '../mathable'
class TeamsManager
  include Mathable
  attr_reader :location,
              :parent,
              :teams

  def self.get_data(location, parent)
    teams = []
    CSV.foreach(location, headers: true, header_converters: :symbol) do |row|
      teams << Team.new(row, self)
    end

    new(location, parent, teams)
  end

  def initialize(location, parent, teams)
    @location = location
    @parent = parent
    @teams = teams
  end

  def get_team_name(accurate_team_id)
    team = teams.find do |team|
      team.team_id == accurate_team_id
    end
    team.team_name
  end

  def team_info(team_id)
    @teams.each_with_object({}) do |team, breakdown|
      if team.team_id == team_id
        breakdown["team_id"] = team.team_id
        breakdown["franchise_id"] = team.franchise_id
        breakdown["team_name"] = team.team_name
        breakdown["abbreviation"] = team.abbreviation
        breakdown["link"] = team.link
      end
    end
  end

  def count_of_teams
    teams.count
  end
end
