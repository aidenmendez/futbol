class GameTeamsManager
  attr_reader :location,
              :parent,
              :game_teams

  def self.get_data(location, parent)
    game_teams = []
    CSV.foreach(location, headers: true, header_converters: :symbol) do |row|
      game_teams << GameTeam.new(row, self)
    end

    new(location, parent, game_teams)
  end

  def initialize(location, parent, game_teams)
    @location = location
    @parent = parent
    @game_teams = game_teams
  end

  def winningest_coach(season)
    coach_count(season, "winningest")
  end

  def worst_coach(season)
    coach_count(season, "worst")
  end

  def coach_count(season, status)
    season = season.to_s
    season_game_teams = game_team_by_season(season)
    coaches = coaches_by_season(season, season_game_teams)
    coach_stats = get_stats(coaches, season, season_game_teams)
    coach_win_percentage = calc_coach_percentage(coach_stats)
    if status == "winningest"
      coach_win_percentage.max_by do |coach, percent|
        percent
      end[0]
    elsif status == "worst"
      coach_win_percentage.min_by do |coach, percent|
        percent
      end[0]
    end
  end

  def game_team_by_season(season)
    games_in_season = game_ids_by_season(season)
    game_teams.find_all do |game_team|
      games_in_season.include?(game_team.game_id)
    end
  end

  def game_ids_by_season(season)
    @parent.game_ids_by_season(season)
  end

  def coaches_by_season(season, season_game_teams)
    coaches = {}

    season_game_teams.each do |game_team|
      coaches[game_team.head_coach] = {:games => 0, :wins => 0}
    end
    coaches
  end

  def get_stats(coaches, season, season_game_teams)
    season_game_teams.each do |game_team|
      if coaches[game_team.head_coach]
        coaches[game_team.head_coach][:games] += 1
        coaches[game_team.head_coach][:wins] += 1 if game_team.result == "WIN"
      end
    end
    coaches
  end

  def calc_coach_percentage(coach_stats)
    percentages = {}
    coach_stats.each do |coach, stat|
      percentages[coach] = calc_percentage(stat[:wins], stat[:games])
    end
    percentages
  end

  def total_games
    game_teams.count / 2
  end

  def percentage_home_wins
    home_wins = 0
    game_teams.each do |game_team|
      home_wins += 1 if game_team.result == "WIN" && game_team.hoa == "home"
    end
    calc_percentage(home_wins, total_games)
  end

  def percentage_visitor_wins
    visitor_wins = 0
    game_teams.each do |game_team|
      visitor_wins += 1 if game_team.result == "WIN" && game_team.hoa == "away"
    end
    calc_percentage(visitor_wins, total_games)
  end

  def percentage_ties
    ties = 0
    game_teams.each do |game_team|
      ties += 0.5 if game_team.result == "TIE"
    end
    calc_percentage(ties, total_games)
  end

  def calc_percentage(numerator, denominator)
    (numerator.to_f / denominator).round(2)
  end

  def most_accurate_team(season)
    accurate_team(season, "most")
  end

  def least_accurate_team(season)
    accurate_team(season, "least")
  end

  def accurate_team(season, status)
    season = season.to_s
    seasonal_games = game_team_by_season(season)
    team_stats = get_game_stats(season, seasonal_games)

    if status == "most"
      accurate_team_id = team_stats.max_by do |team_id, stats|
        stats[:goals].to_f / stats[:shots]
      end[0]
    elsif status == "least"
      accurate_team_id = team_stats.min_by do |team_id, stats|
        stats[:goals].to_f / stats[:shots]
      end[0]
    end

    parent.get_team_name(accurate_team_id)
  end

  def get_game_stats(season, seasonal_games)
    team_stats = {}
    seasonal_games.each do |seasonal_game|
      if !team_stats.key?(seasonal_game.team_id)
        team_stats[seasonal_game.team_id] = {
          :shots => seasonal_game.shots,
          :goals => seasonal_game.goals,
          :tackles => seasonal_game.tackles
        }
      else
        team_stats[seasonal_game.team_id][:shots] += seasonal_game.shots
        team_stats[seasonal_game.team_id][:goals] += seasonal_game.goals
        team_stats[seasonal_game.team_id][:tackles] += seasonal_game.tackles
      end
    end
    team_stats
  end

  def most_tackles(season)
    tackles(season, "most")
  end

  def fewest_tackles(season)
    tackles(season, "fewest")
  end

  def tackles(season, status)
    season = season.to_s
    seasonal_games = game_team_by_season(season)
    team_stats = get_game_stats(season, seasonal_games)

    if status == "most"
      tackles_team_id = team_stats.max_by do |team_id, stats|
        stats[:tackles]
      end[0]
    elsif status == "fewest"
      tackles_team_id = team_stats.min_by do |team_id, stats|
        stats[:tackles]
      end[0]
    end

    parent.get_team_name(tackles_team_id)
  end

  def average_win_percentage(team_id)
    total_win = 0
    total_game = 0
    @game_teams.each do |game_team|
      if game_team.team_id == team_id
        if game_team.result == "WIN"
          total_win += 1
        end
        total_game += 1
      end
    end
    (total_win.to_f / total_game).round(2)
  end

  def most_goals_scored(team_id)
    most_goals = 0
    @game_teams.each do |game_team|
      if game_team.team_id == team_id
        most_goals = game_team.goals if most_goals < game_team.goals
      end
    end
    most_goals
  end

  def fewest_goals_scored(team_id)
    least_goals = 0
    @game_teams.each do |game_team|
      if game_team.team_id == team_id
        least_goals = game_team.goals if least_goals > game_team.goals
      end
    end
    least_goals
  end
  
  
  # def count_team_games(team_id)
  #   hash = {}
  #   game_teams.each do |game_team|
  #     next if game_team[team_id] != team_id
  #     hash[game_team.game_id] = {:win => false} 
  #     if game_team[:result] == "WIN"
  #       hash[game_team.game_id][:win] = true
  #     end

  #     hash
  #   end
  # end
  def best_offense
    team_stats = {}
    game_teams.each do |game_team|
      if team_stats[game_team.team_id]
        team_stats[game_team.team_id][:total_goals] += game_team.goals
        team_stats[game_team.team_id][:total_games] += 1
      else
        team_stats[game_team.team_id] = {total_games: 1, total_goals: game_team.goals}
      end
    end
    top_offense_team = team_stats.max_by do |team, stats|
      stats[:total_goals].to_f / stats[:total_games]
    end[0]
    parent.get_team_name(top_offense_team)
  end

  def worst_offense
    team_stats = {}
    game_teams.each do |game_team|
      if team_stats[game_team.team_id]
        team_stats[game_team.team_id][:total_goals] += game_team.goals
        team_stats[game_team.team_id][:total_games] += 1
      else
        team_stats[game_team.team_id] = {total_games: 1, total_goals: game_team.goals}
      end
    end
    worst_offense_team = team_stats.min_by do |team, stats|
      stats[:total_goals].to_f / stats[:total_games]
    end[0]
    parent.get_team_name(worst_offense_team)
  end
end
