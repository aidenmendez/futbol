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

  def calc_percentage(numerator, denominator)
    (numerator.to_f / denominator).round(2)
  end
end