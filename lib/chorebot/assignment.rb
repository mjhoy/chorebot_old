require 'date'

# An assignment represents that a chore was assigned to a doer on a
# certain date for a certain level of difficulty (whatever difficulty
# the chore was defined at, at the time)
class Assignment
  attr_reader :doer, :chore, :difficulty, :date

  def initialize doer, chore, difficulty, date
    @doer = doer
    @chore = chore
    @difficulty = difficulty
    @date = date
  end
end
