class Doer

  attr_reader :name, :email, :assigned, :vetoes, :absent

  def initialize name, email, assigned, vetoes, absent
    @name = name
    @email = email
    @assigned = assigned
    @vetoes = vetoes
    @absent = absent
  end

  def to_email_address
    "#{name} <#{email}>"
  end


  def heading_string
    to_email_address
  end

  def self.parse string, filename
    doers = []

    lines = string.lines
    line_num = 0

    currently_parsing_doer = false

    # parsing state
    name = nil
    email = nil
    assigned = []
    vetoes = []
    absent = []

    errors = []

    # loop over the lines

    lines.each do |l|
      line_num += 1

      # Whitespace or comment
      if l.match(/^#/) || l.match(/^\s*$/)
        if currently_parsing_doer
          doers << Doer.new(name, email, assigned, vetoes, absent)
          name = nil
          email = nil
          assigned = []
          vetoes = []
          absent = []

          currently_parsing_doer = false
        end
      else
        if !currently_parsing_doer
          currently_parsing_doer = true
          # First line of the doer
          if m = l.match(/(.+)\s<([^>]+)>$/)
            name = m[1]
            email = m[2]
          else
            errors << "#{filename}: line #{line_num}: expected doer name and email, bad format?"
          end
        else
          ld = l.downcase
          if ld.start_with? "assigned: "
            assigned = assigned.concat(l[10..-1].chomp.split(",").map(&:strip))
          elsif ld.start_with? "veto: "
            vetoes = vetoes.concat(l[6..-1].chomp.split(",").map(&:strip))
          elsif ld.start_with? "absent: "
            absent = absent.concat(l[8..-1].chomp.split(",").map(&:strip))
          else
            errors << "#{filename}: line #{line_num}: expected Assigned: Veto: or Absent:, found: \"#{l.chomp}\""
          end
        end
      end
    end

    if currently_parsing_doer
      doers << Doer.new(name, email, assigned, vetoes, absent)
    end

    if errors.length > 0
      Result.err errors.join("\n")
    else
      Result.ok doers
    end
  end
end
