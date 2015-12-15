require 'result'

class Chore
  DIFFICULTY = {
    "hard" => 7,
    "medium" => 4,
    "easy" => 2
  }

  attr_reader :title, :interval, :difficulty, :description

  # chore represented as a string
  def to_s
    str = heading_string
    if description
      str = str + "\n" + description
    end
    str
  end

  # string representation, no description
  def heading_string
    "#{title}: #{interval} #{difficulty_string}"
  end

  def difficulty_string
    str = nil
    DIFFICULTY.each do |k,v|
      if v == difficulty
        str = k
      end
    end
    str.capitalize
  end

  def initialize title, interval, difficulty, description
    @title = title
    @interval = interval
    @difficulty = difficulty
    @description = description
  end

  # Parse chores from a string
  # see the readme file for expected format.
  def self.parse string, filename
    chores = []

    lines = string.lines
    line_num = 0

    # toggled when we hit a non-comment, non-whitespace line
    currently_parsing_chore = false

    # parsing state
    title = nil
    difficulty = nil
    interval = nil
    description = nil

    errors = []

    # loop over the lines
    lines.each do |l|
      line_num += 1

      # Whitespace or comment
      if l.match(/^#/) || l.match(/^\s*$/)
        if currently_parsing_chore # the current chore is finished
          chores << Chore.new(title, interval, difficulty, description)
          title = nil
          difficulty = nil
          interval = nil
          description = nil

          currently_parsing_chore = false
        end
      else
        if !currently_parsing_chore
          currently_parsing_chore = true
          # First line of the chore
          if m = l.match(/([^:]+):\s+(\d+)\s(\w+)/)
            title = m[1]
            interval = m[2].to_i
            difficulty = DIFFICULTY[m[3].downcase]
            if difficulty.nil?
              errors << "#{filename}: line #{line_num}: don't recognize #{m[3]} as a valid difficulty"
            end
          else
            errors << "#{filename}: line #{line_num}: expected chore name, interval, difficulty, bad format?"
          end
        else
          # description
          description = "" unless description
          description << l
        end
      end
    end

    # run this code at the end in case there is no empty line at
    # the end of the file.
    if currently_parsing_chore
      chores << Chore.new(title, interval, difficulty, description)
      title = nil
      difficulty = nil
      interval = nil
      description = nil
    end

    if errors.length > 0
      Result.err errors.join("\n")
    else
      Result.ok chores
    end
  end
end

