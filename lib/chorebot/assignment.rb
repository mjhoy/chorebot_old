require 'date'
require 'chorebot/result'

# An assignment represents that a chore was assigned to a doer on a
# certain date for a certain level of difficulty (whatever difficulty
# the chore was defined at, at the time)
class Assignment
  attr_reader :doer, :chore, :difficulty, :date

  def initialize doer, chore, difficulty=nil, date=nil
    @doer = doer
    @chore = chore
    if difficulty.nil?
      @difficulty = chore.difficulty
    else
      @difficulty = difficulty
    end
    if date.nil?
      @date = Date.today
    else
      @date = date
    end
  end

  def to_s
    <<TEXT
[#{ date.to_s }]
Chore: #{ chore.title } (#{difficulty})
Doer: #{ doer.heading_string }
TEXT
  end

  def to_string_without_date
    <<TEXT
Chore: #{ chore.title } (#{difficulty})
Doer: #{ doer.heading_string }
TEXT
  end

  # parse the assignments file.
  #
  # the format is something like this:
  #
  #   == 2015/12/21
  #   Chore: Clean fridge (2)
  #   Doer: Randal Peltzer <randal@yahoo.com>
  #
  #   Chore: Scrub tub (1)
  #   Doer: Jane Doe <jane@jane.com>
  #
  # Chore assignments are broken up into days, begining with "==" and
  # with the format YYYY/MM/DD.
  #
  # Additionally, `doers' and `chores' must be passed into this
  # function for the assignment to get correctly initalized. The doers
  # are matched on email, and the chore is matched on title.
  def self.parse string, filename, chores, doers
    assignments = []
    errors = []

    lines = string.lines
    line_num = 0

    currently_parsing_assignment = false

    # regexes
    date_re = /^==\s+(\d{4})\/(\d{2})\/(\d{2})/
    chore_diff_re = /^chore:\s+([^\(]+)\s+\((\d+\))/i
    doer_re = /^doer:\s+[^<]+<([^>]+)>/i

    # parsing state
    date = nil
    doer = nil
    chore = nil
    difficulty = nil

    # loop over the lines
    lines.each do |l|
      line_num += 1

      # Whitespace or comment
      if l.match(/^#/) || l.match(/^\s*$/)
        if currently_parsing_assignment
          assignments << Assignment.new(doer, chore, difficulty, date)
          # date carries over and does not get reset to nil.
          doer = nil
          chore = nil
          difficulty = nil

          currently_parsing_assignment = false
        end
      else
        if !date && (!l.match(date_re))
          errors << "#{filename}: line #{line_num}: expected date set, bad format?"
        else
          if m = l.match(date_re)
            year = m[1].to_i
            month = m[2].to_i
            day = m[3].to_i
            date = Date.new year, month, day
          elsif m = l.match(chore_diff_re)
            currently_parsing_assignment = true
            chore_title = m[1]
            difficulty = m[2].to_i
            chore = chores.detect { |c| c.title.downcase == chore_title.downcase }
          elsif m = l.match(doer_re)
            currently_parsing_assignment = true
            doer_email = m[1]
            doer = doers.detect { |d| d.email.downcase == doer_email.downcase }
          end
        end
      end
    end

    if currently_parsing_assignment
      assignments << Assignment.new(doer, chore, difficulty, date)
    end

    if errors.length > 0
      Result.err errors.join("\n")
    else
      Result.ok assignments
    end
  end
end
