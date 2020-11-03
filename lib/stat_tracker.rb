require_relative './stat_tracker'
require_relative './model/game_team'
require_relative './model/game'
require_relative './model/team'
require_relative './manager/game_teams_manager'
require_relative './manager/manager'
require_relative './manager/teams_manager'
require_relative './manager/games_manager'

class StatTracker
  attr_reader :games_path, 
              :game_teams_path, 
              :teams_path,
              :game_teams_manager,
              :games_manager,
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

  def highest_total_score
    @games_manager.highest_total_score
  end

  def lowest_total_score
    @games_manager.lowest_total_score
  end

  def average_goals_per_game
    @games_manager.average_goals_per_game
  end

  def average_goals_by_season
    @games_manager.average_goals_by_season
  end

  def best_season(team_id)
    @games_manager.best_season(team_id)
  end

  def worst_season(team_id)
    @games_manager.worst_season(team_id)
  end

  def favorite_opponent(team_id)
    @games_manager.favorite_opponent(team_id)
  end

  def rival(team_id)
    @games_manager.rival(team_id)
  end

  def winningest_coach(season)
    @game_teams_manager.winningest_coach(season)
  end

  def worst_coach(season)
    @game_teams_manager.worst_coach(season)
  end

  def percentage_home_wins 
    @game_teams_manager.percentage_home_wins 
  end

  def percentage_visitor_wins 
    @game_teams_manager.percentage_visitor_wins 
  end

  def percentage_ties
    @game_teams_manager.percentage_ties
  end

  def most_accurate_team(season)
    @game_teams_manager.most_accurate_team(season)
  end

  def least_accurate_team(season)
    @game_teams_manager.least_accurate_team(season)
  end

  def most_tackles(season)
    @game_teams_manager.most_tackles(season)
  end

  def fewest_tackles(season)
    @game_teams_manager.fewest_tackles(season)
  end
  

  def average_win_percentage(team_id)
    @game_teams_manager.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    @game_teams_manager.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @game_teams_manager.fewest_goals_scored(team_id)
  end

  def team_info(team_id)
    @teams_manager.team_info(team_id)
  end

  def count_of_teams
    @teams_manager.count_of_teams
  end
  
  def best_offense
    @game_teams_manager.best_offense
  end

  def worst_offense
    @game_teams_manager.worst_offense
  end

  def highest_scoring_visitor
    @games_manager.highest_scoring_visitor
  end

  def highest_scoring_home_team
    @games_manager.highest_scoring_home_team
  end

  def lowest_scoring_visitor
    @games_manager.lowest_scoring_visitor
  end

  def lowest_scoring_home_team
    @games_manager.lowest_scoring_home_team
  end
end