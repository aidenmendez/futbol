class TeamsManager
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
    team_name = teams.find do |team|
      team.team_id == accurate_team_id
    end.team_name
  end

  def count_of_teams
    teams.count
  end
end
