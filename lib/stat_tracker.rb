require 'csv'

class StatTracker
  attr_reader :games_path,
              :game_teams_path,
              :teams_path,
              :game_teams_manager,
              :games_manager,
              :game,
              :team,
              :teams_manager

  def self.from_csv(locations)
    new(locations)
  end

  def initialize(locations)
    @games_path = locations[:games]
    @game_teams_path = locations[:game_teams]
    @teams_path = locations[:teams]
    @games_manager = GamesManager.get_data(games_path, self)
    @game_teams_manager = GameTeamsManager.get_data(game_teams_path, self)
    @teams_manager = TeamsManager.get_data(teams_path, self)
  end

  def game_ids_by_season(season)
    @games_manager.game_ids_by_season(season)
  end

  def get_team_name(accurate_team_id)
    @teams_manager.get_team_name(accurate_team_id)
  end


  # ===============================================================


  # def winningest_coach(season)
  #   season = season.to_s
  #   coaches_by_id = {}
  #   game_counts = {}
  #   team_percentage = {}
  #   # generate coaches_by_id key/value pairs
  #   CSV.foreach(game_teams, headers: true, header_converters: :symbol) do |row|
  #     next if coaches_by_id.key?(row[:team_id])
  #     coaches_by_id[row[:team_id]] = row[:head_coach]
  #   end
  #   # generate empty game_counts key/value pairs
  #   CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
  #     next if row[:season] != season
  #     game_counts[row[:home_team_id]] = [0, 0] if !game_counts.key?(row[:home_team_id])

  #     game_counts[row[:away_team_id]] = [0, 0] if !game_counts.key?(row[:away_team_id])
  #   end
  #   # generate wins and total games for game_counts values array
  #   CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
  #     next if row[:season] != season
  #     game_counts[row[:home_team_id]][1] += 1
  #     game_counts[row[:away_team_id]][1] += 1
  #     if row[:away_goals] > row[:home_goals]
  #       game_counts[row[:away_team_id]][0] += 1
  #     elsif row[:home_goals] > row[:away_goals]
  #       game_counts[row[:home_team_id]][0] += 1
  #     end
  #   end

  #   game_counts.each do |team_id, data|
  #     percentage = calc_percentage(data[0], data[1])
  #     team_percentage[team_id] = percentage
  #   end
  #   winning_team = team_percentage.max_by do |team_id, percentage|
  #     percentage
  #   end
  #   winning_coach = coaches_by_id[winning_team[0]]
  # end

  # def worst_coach(season)
  #   season = season.to_s
  #   coaches_by_id = {}
  #   game_counts = {}
  #   team_percentage = {}
  #   # generate coaches_by_id key/value pairs
  #   CSV.foreach(game_teams, headers: true, header_converters: :symbol) do |row|
  #     next if coaches_by_id.key?(row[:team_id])
  #     coaches_by_id[row[:team_id]] = row[:head_coach]
  #   end
  #   # generate empty game_counts key/value pairs
  #   CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
  #     next if row[:season] != season
  #     game_counts[row[:home_team_id]] = [0, 0] if !game_counts.key?(row[:home_team_id])

  #     game_counts[row[:away_team_id]] = [0, 0] if !game_counts.key?(row[:away_team_id])
  #   end
  #   # generate wins and total games for game_counts values array
  #   CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
  #     next if row[:season] != season
  #     game_counts[row[:home_team_id]][1] += 1
  #     game_counts[row[:away_team_id]][1] += 1
  #     if row[:away_goals] > row[:home_goals]
  #       game_counts[row[:away_team_id]][0] += 1
  #     elsif row[:home_goals] > row[:away_goals]
  #       game_counts[row[:home_team_id]][0] += 1
  #     end
  #   end

  #   game_counts.each do |team_id, data|
  #     percentage = calc_percentage(data[0], data[1])
  #     team_percentage[team_id] = percentage
  #   end
  #   losing_team = team_percentage.min_by do |team_id, percentage|
  #     percentage
  #   end
  #   losing_coach = coaches_by_id[losing_team[0]]
  # end


  # def least_accurate_team(season_id)
  #   season_id = season_id.to_s
  #   team_stats = {}
  #   game_id_per_season = []

  #   CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
  #     game_id_per_season << row[:game_id] if row[:season] == season_id
  #   end

  #   CSV.foreach(game_teams, headers: true, header_converters: :symbol) do |row|
  #     next if !game_id_per_season.include?(row[:game_id])
  #     if team_stats[row[:team_id]]
  #       team_stats[row[:team_id]][:shots] += row[:shots].to_i
  #       team_stats[row[:team_id]][:goals] += row[:goals].to_i
  #     else
  #       team_stats[row[:team_id]] = {shots: row[:shots].to_i, goals: row[:goals].to_i}
  #     end
  #   end

  #   least_accurate_team_id = team_stats.min_by do |team_id, stats|
  #     stats[:goals].to_f / stats[:shots]
  #   end[0]

  #   CSV.foreach(teams, headers: true, header_converters: :symbol) do |row|
  #     return row[:teamname] if row[:team_id] == least_accurate_team_id
  #   end
  # end

  # def most_tackles(season_id)
  #   season_id = season_id.to_s
  #   season_game_ids = []
  #   most_tackles = {}
  #   CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
  #     season_game_ids << row[:game_id] if row[:season] == season_id
  #   end
  #   CSV.foreach(game_teams, headers: true, header_converters: :symbol) do |row|
  #     next if !season_game_ids.include?(row[:game_id])
  #     if most_tackles[row[:team_id]]
  #       most_tackles[row[:team_id]][:total_tackles] += row[:tackles].to_i
  #     else
  #       most_tackles[row[:team_id]] = {total_tackles: row[:tackles].to_i}
  #     end
  #   end
  #   team = most_tackles.max_by do |key, val|
  #     val[:total_tackles]
  #   end[0]
  #   CSV.foreach(teams, headers:true, header_converters: :symbol) do |row|
  #     return row[:teamname] if team == row[:team_id]
  #   end
  # end

  # def fewest_tackles(season_id)
  #   season_id = season_id.to_s
  #   season_game_ids = []
  #   least_tackles = {}
  #   CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
  #     season_game_ids << row[:game_id] if row[:season] == season_id
  #   end
  #   CSV.foreach(game_teams, headers: true, header_converters: :symbol) do |row|
  #     next if !season_game_ids.include?(row[:game_id])
  #     if least_tackles[row[:team_id]]
  #       least_tackles[row[:team_id]][:total_tackles] += row[:tackles].to_i
  #     else
  #       least_tackles[row[:team_id]] = {total_tackles: row[:tackles].to_i}
  #     end
  #   end
  #   team = least_tackles.min_by do |key, val|
  #     val[:total_tackles]
  #   end[0]
  #   CSV.foreach(teams, headers:true, header_converters: :symbol) do |row|
  #     return row[:teamname] if team == row[:team_id]
  #   end
  # end

  def team_info(team_id)
    team_infos = {}
    CSV.foreach(teams, headers: true) do |row|
      if row["team_id"] == team_id
        team_infos["team_id"] = row["team_id"]
        team_infos["franchise_id"] = row["franchiseId"]
        team_infos["team_name"] = row["teamName"]
        team_infos["abbreviation"] = row["abbreviation"]
        team_infos["link"] = row["link"]
      end
    end
    team_infos
  end

  def best_season(team_id)
    seasons = {}
    CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
      if row[:home_team_id] == team_id
        if seasons[row[:season]]
          seasons[row[:season]][:total_games] += 1
          seasons[row[:season]][:total_home_wins] += 1 if row[:home_goals] > row[:away_goals]
        else
          seasons[row[:season]] = { total_games: 1,
                                    total_home_wins: 1,
                                    total_away_wins: 0 }
        end
      end
    end
    CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
      if row[:away_team_id] == team_id
        if seasons[row[:season]]
          seasons[row[:season]][:total_games] += 1
          seasons[row[:season]][:total_away_wins] += 1 if row[:away_goals] > row[:home_goals]
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
    CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
      if row[:home_team_id] == team_id
        if seasons[row[:season]]
          seasons[row[:season]][:total_games] += 1
          seasons[row[:season]][:total_home_wins] += 1 if row[:home_goals] > row[:away_goals]
        else
          seasons[row[:season]] = { total_games: 1,
                                    total_home_wins: 1,
                                    total_away_wins: 0 }
        end
      end
    end
    CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
      if row[:away_team_id] == team_id
        if seasons[row[:season]]
          seasons[row[:season]][:total_games] += 1
          seasons[row[:season]][:total_away_wins] += 1 if row[:away_goals] > row[:home_goals]
        else
        end
      end
    end
      worst_win_rate = seasons.min_by do |season, stats|
        ((stats[:total_home_wins] + stats[:total_away_wins]).to_f * 100 / stats[:total_games]).round(2)
      end
      worst_win_rate[0]
  end

  def average_win_percentage(team_id)
    total_win = 0
    total_game = 0
    CSV.foreach(game_teams, headers: true, header_converters: :symbol) do |row|
      if row[:team_id] == team_id
        if row[:result] == "WIN"
          total_win += 1
        end
        total_game += 1
      end
    end
    (total_win.to_f / total_game).round(2)
  end

  def most_goals_scored(team_id)
    most_goals = 0
    CSV.foreach(game_teams, headers: true, header_converters: :symbol) do |row|
      if row[:team_id] == team_id
        most_goals = row[:goals].to_i if most_goals < row[:goals].to_i
      end
    end
    most_goals
  end

  def fewest_goals_scored(team_id)
    least_goals = 0
    CSV.foreach(game_teams, headers: true, header_converters: :symbol) do |row|
      if row[:team_id] == team_id
        least_goals = row[:goals].to_i if least_goals > row[:goals].to_i
      end
    end
    least_goals
  end

  def favorite_opponent(team_id)
    favorite_opponents = {}
    CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
      if row[:home_team_id] == team_id
        if favorite_opponents[row[:away_team_id]]
          favorite_opponents[row[:away_team_id]][:total_games] += 1
          favorite_opponents[row[:away_team_id]][:total_home_wins] += 1 if row[:home_goals] > row[:away_goals]
        else
          favorite_opponents[row[:away_team_id]] = { total_games: 1,
                                                    total_home_wins: 1,
                                                    total_away_wins: 0}
        end
      end
    end
    CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
      if row[:away_team_id] == team_id
        if favorite_opponents[row[:home_team_id]]
          favorite_opponents[row[:home_team_id]][:total_games] += 1
          favorite_opponents[row[:home_team_id]][:total_away_wins] += 1 if row[:away_goals] > row[:home_goals]
        end
      end
    end
    best_win_rate = favorite_opponents.max_by do |opponent, stats|
      ((stats[:total_home_wins] + stats[:total_away_wins]).to_f * 100 / stats[:total_games]).round(2)
    end[0]
    CSV.foreach(teams, headers:true, header_converters: :symbol) do |row|
      return row[:teamname] if best_win_rate == row[:team_id]
    end
  end

  def rival(team_id)
    favorite_opponents = {}
    CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
      if row[:home_team_id] == team_id
        if favorite_opponents[row[:away_team_id]]
          favorite_opponents[row[:away_team_id]][:total_games] += 1
          favorite_opponents[row[:away_team_id]][:total_home_wins] += 1 if row[:home_goals] > row[:away_goals]
        else
          favorite_opponents[row[:away_team_id]] = { total_games: 1,
                                                    total_home_wins: 1,
                                                    total_away_wins: 0}
        end
      end
    end
    CSV.foreach(games, headers: true, header_converters: :symbol) do |row|
      if row[:away_team_id] == team_id
        if favorite_opponents[row[:home_team_id]]
          favorite_opponents[row[:home_team_id]][:total_games] += 1
          favorite_opponents[row[:home_team_id]][:total_away_wins] += 1 if row[:away_goals] > row[:home_goals]
        end
      end
    end
    worst_win_rate = favorite_opponents.min_by do |opponent, stats|
      ((stats[:total_home_wins] + stats[:total_away_wins]).to_f * 100 / stats[:total_games]).round(2)
    end[0]
    CSV.foreach(teams, headers:true, header_converters: :symbol) do |row|
      return row[:teamname] if worst_win_rate == row[:team_id]
    end
  end
end
