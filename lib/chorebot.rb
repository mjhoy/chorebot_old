#!/usr/bin/ruby -w


require 'chorebot/result'
require 'chorebot/chore'
require 'chorebot/doer'

class ChoreBot
  def is_chorebot?
    false # classified
  end

  def list_chores
    filename = "chores.txt"
    text = File.open(filename, 'rb') { |f| f.read }
    res = Chore.parse text, filename
    if res.ok?
      chores = res.result
      chores.each do |c|
        puts c.heading_string
      end
    else
      STDERR.puts "Error: #{res.error}"
      exit 1
    end
  end

  def list_doers
    filename = "doers.txt"
    text = File.open(filename, 'rb') { |f| f.read }
    res = Doer.parse text, filename
    if res.ok?
      doers = res.result
      doers.each do |c|
        puts c.heading_string
      end
    else
      STDERR.puts "Error: #{res.error}"
      exit 1
    end
  end
end

