# Sum up Away and Home team's score per game_id
# Get data by col
  # Col by winning score + Col by losing score
# Parse CSV table initially and save as instance variable
# Method will iterate through instance variable
require 'csv'

class StatTracker
  attr_reader :games, :game_teams, :teams
  def self.from_csv(locations)
    new(locations)
  end

  def initialize(locations)
    @games = locations[:games]
    @game_teams = locations[:game_teams]
    @teams = locations[:teams]
  end

  def highest_total_score # Rename later, for now from Games Table
    most = 0
    CSV.foreach(games, :headers => true, header_converters: :symbol) do |row|
      total = row[:away_goals].to_i + row[:home_goals].to_i
      most = total if total > most
    end
    most
  end

  def lowest_total_score
    least = 1000
    CSV.foreach(games, :headers => true, header_converters: :symbol) do |row|
      total = row[:home_goals].to_i + row[:away_goals].to_i
      least = total if total < least
    end
    least
  end

end
