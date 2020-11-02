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
end