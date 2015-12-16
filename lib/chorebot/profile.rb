require 'date'

# A profile object represents a doer's "chore profile" over time:
# information about the average chore difficulty taken on per day, the
# most recent chores performed, etc.
class Profile
  attr_reader :assignments, :doer, :current_date

  def initialize doer, assignments, current_date=Date.today
    @assignments = assignments
    @doer = doer
    @current_date = current_date
  end

  def average_difficulty_per_day
    return 0 if assignments.empty?
    total_difficulty = assignments.inject(0) { |x, a| x + a.difficulty }
    earliest_chore = assignments.inject(current_date) { |d, a| d > a.date ? a.date : d }
    days_since_start = current_date - earliest_chore
    total_difficulty.to_f / days_since_start
  end

  def most_recent_chores
    return [] if assignments.empty?
    latest_chore = assignments.inject(Date.new) { |d, a| d < a.date ? a.date : d }
    assignments.map {|a| a.chore if a.date == latest_chore }.compact.sort
  end
end
