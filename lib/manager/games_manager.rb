class GamesManager
  attr_reader :location,
              :parent,
              :games

  def self.get_data(location, parent)
    games = []
    CSV.foreach(location, headers: true, header_converters: :symbol) do |row|
      games << Game.new(row, self)
    end
    new(location, parent, games)
  end

  def initialize(location, parent, games)
    @location = location
    @parent = parent
    @games = games
  end

  def highest_total_score
    games.max_by { |game| game.total_score }.total_score
  end

  def lowest_total_score
    games.min_by { |game| game.total_score }.total_score
  end

  def game_ids_by_season(season)
    games_by_season = games.find_all do |game|
      game.season == season
    end
    games_by_season = games_by_season.map! do |game|
      game.game_id
    end
  end

  def count_of_games_by_season
    season_games = Hash.new(0)
    games.each do |game|
      season_games[game.season] += 1
    end
    season_games
  end
end