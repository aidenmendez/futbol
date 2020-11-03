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

  def average_goals_per_game
    total_goals = games.reduce(0) do |sum, game|
      sum + game.total_score
    end
    (total_goals.to_f / (games.count)).round(2)
  end

  def average_goals_by_season
    season_average_goals = count_of_games_by_season
    seasons = season_average_goals.keys
    seasons.each do |season|
      total_goals = 0

      games.each do |game|
        next if season != game.season
        total_goals += game.total_score
      end

      avg = (total_goals.to_f / season_average_goals[season]).round(2)
      season_average_goals[season] = avg
    end
    season_average_goals
  end

  def highest_scoring_visitor
    team_stats = {}
    games.each do |game|
      if team_stats[game.away_team_id]
        team_stats[game.away_team_id][:total_away_goals] += game.away_goals
        team_stats[game.away_team_id][:total_away_games] += 1
      else
        team_stats[game.away_team_id] = {total_away_games: 1, total_away_goals: game.away_goals}
      end
    end
    highest_scoring_away_team_id = team_stats.max_by do |team, stats|
      stats[:total_away_goals].to_f / stats[:total_away_games]
    end[0]

    parent.get_team_name(highest_scoring_away_team_id)
  end

  def highest_scoring_home_team
    team_stats = {}
    games.each do |game|
      if team_stats[game.home_team_id]
        team_stats[game.home_team_id][:total_home_goals] += game.home_goals
        team_stats[game.home_team_id][:total_home_games] += 1
      else
        team_stats[game.home_team_id] = {total_home_games: 1, total_home_goals: game.home_goals}
      end
    end
    highest_scoring_home_team_id = team_stats.max_by do |team, stats|
      stats[:total_home_goals].to_f / stats[:total_home_games]
    end[0]

    parent.get_team_name(highest_scoring_home_team_id)
  end

  def lowest_scoring_visitor
    team_stats = {}
    games.each do |game|
      if team_stats[game.away_team_id]
        team_stats[game.away_team_id][:total_away_goals] += game.away_goals
        team_stats[game.away_team_id][:total_away_games] += 1
      else
        team_stats[game.away_team_id] = {total_away_games: 1, total_away_goals: game.away_goals}
      end
    end
    lowest_scoring_away_team_id = team_stats.min_by do |team, stats|
      stats[:total_away_goals].to_f / stats[:total_away_games]
    end[0]

    parent.get_team_name(lowest_scoring_away_team_id)
  end

  def lowest_scoring_home_team
    team_stats = {}
    games.each do |game|
      if team_stats[game.home_team_id]
        team_stats[game.home_team_id][:total_home_goals] += game.home_goals
        team_stats[game.home_team_id][:total_home_games] += 1
      else
        team_stats[game.home_team_id] = {total_home_games: 1, total_home_goals: game.home_goals}
      end
    end
    lowest_scoring_home_team_id = team_stats.min_by do |team, stats|
      stats[:total_home_goals].to_f / stats[:total_home_games]
    end[0]

    parent.get_team_name(lowest_scoring_home_team_id)
  end

  def best_season(team_id)
    seasons = {}
    @games.each do |game|
      if game.home_team_id == team_id
        if seasons[game.season]
          seasons[game.season][:total_games] += 1
          seasons[game.season][:total_home_wins] += 1 if game.home_goals > game.away_goals
        else
          seasons[game.season] = { total_games: 1, 
                                  total_home_wins: 1,
                                  total_away_wins: 0 }
        end
      end
    end
    @games.each do |game|
      if game.away_team_id == team_id
        if seasons[game.season]
          seasons[game.season][:total_games] += 1
          seasons[game.season][:total_away_wins] += 1 if game.home_goals < game.away_goals
        end
      end
    end
      best_win_rate = seasons.max_by do |season, stats|
        ((stats[:total_home_wins] + stats[:total_away_wins]).to_f * 100 / stats[:total_games]).round(2)
      end
      best_win_rate[0]
  end

  def worst_season(team_id)
    seasons = {}
    @games.each do |game|
      if game.home_team_id == team_id
        if seasons[game.season]
          seasons[game.season][:total_games] += 1
          seasons[game.season][:total_home_wins] += 1 if game.home_goals > game.away_goals
        else
          seasons[game.season] = { total_games: 1, 
                                    total_home_wins: 1,
                                    total_away_wins: 0 }
        end
      end
    end
    @games.each do |game|
      if game.away_team_id == team_id
        if seasons[game.season]
          seasons[game.season][:total_games] += 1
          seasons[game.season][:total_away_wins] += 1 if game.home_goals < game.away_goals
        end
      end
    end
      worst_win_rate = seasons.min_by do |season, stats|
        ((stats[:total_home_wins] + stats[:total_away_wins]).to_f * 100 / stats[:total_games]).round(2)
      end
      worst_win_rate[0]
    end

  def favorite_opponent(team_id)
    favorite_opponents = {}
    @games.each do |game|
      if game.home_team_id == team_id
        if favorite_opponents[game.away_team_id]
          favorite_opponents[game.away_team_id][:total_games] += 1
          favorite_opponents[game.away_team_id][:total_home_wins] += 1 if game.home_goals > game.away_goals
        else
          favorite_opponents[game.away_team_id] = { total_games: 1, 
                                                    total_home_wins: 1, 
                                                    total_away_wins: 0}
        end
      end
    end
    @games.each do |game|
      if game.away_team_id == team_id
        if favorite_opponents[game.home_team_id]
          favorite_opponents[game.home_team_id][:total_games] += 1
          favorite_opponents[game.home_team_id][:total_away_wins] += 1 if game.away_goals > game.home_goals
        end
      end
    end
    best_win_rate = favorite_opponents.max_by do |opponent, stats|
      ((stats[:total_home_wins] + stats[:total_away_wins]).to_f * 100 / stats[:total_games]).round(2)
    end[0]
      @parent.get_team_name(best_win_rate)      
  end

  def rival(team_id)
    favorite_opponents = {}
    @games.each do |game|
      if game.home_team_id == team_id
        if favorite_opponents[game.away_team_id]
          favorite_opponents[game.away_team_id][:total_games] += 1
          favorite_opponents[game.away_team_id][:total_home_wins] += 1 if game.home_goals > game.away_goals
        else
          favorite_opponents[game.away_team_id] = { total_games: 1, 
                                                    total_home_wins: 1, 
                                                    total_away_wins: 0}
        end
      end
    end
    @games.each do |game|
      if game.away_team_id == team_id
        if favorite_opponents[game.home_team_id]
          favorite_opponents[game.home_team_id][:total_games] += 1
          favorite_opponents[game.home_team_id][:total_away_wins] += 1 if game.away_goals > game.home_goals
        end
      end
    end
    best_win_rate = favorite_opponents.min_by do |opponent, stats|
      ((stats[:total_home_wins] + stats[:total_away_wins]).to_f * 100 / stats[:total_games]).round(2)
    end[0]
      @parent.get_team_name(best_win_rate)    
  end
end
