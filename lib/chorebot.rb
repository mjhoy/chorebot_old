#!/usr/bin/ruby -w


require 'chorebot/result'
require 'chorebot/chore'
require 'chorebot/doer'
require 'chorebot/assignment'
require 'chorebot/profile'

class ChoreBot
  def is_chorebot?
    false # classified
  end

  def list_chores
    parse_chores!
    @chores.each do |c|
      puts c.heading_string
    end
  end

  def list_doers
    parse_doers!
    @doers.each do |c|
      puts c.heading_string
    end
  end

  def assign!
    parse_chores!
    parse_doers!

    _doers = @doers.shuffle

    _profiles = _doers.map { |doer| Profile.new doer, [] }

    _chores_to_assign = @chores.sort_by(&:difficulty).reverse
    _new_assignments = []

    # Permanent assignments
    _profiles.each do |profile|
      profile.doer.assigned.each do |chore_title|
        chore = _chores_to_assign.detect { |c| c.title.downcase == chore_title.downcase }
        if chore
          new_assignment = Assignment.new profile.doer, _chores_to_assign.delete(chore)
          profile.assignments << new_assignment
        end
      end
    end

    while !_chores_to_assign.empty? do
      _highest_profile = _profiles.sort_by(&:average_difficulty_per_day).last
      _profiles.each do |profile|
        next if profile == _highest_profile
        if !_chores_to_assign.empty?
          new_assignment = Assignment.new profile.doer, _chores_to_assign.delete_at(0)
          profile.assignments << new_assignment
        end
      end
      _profiles.sort_by!(&:average_difficulty_per_day)
    end

    _profiles.sort_by(&:average_difficulty_per_day).each do |profile|
      puts "#{profile.doer.name}"
      profile.assignments.each do |assignment|
        puts "   #{assignment.chore.title} (#{assignment.difficulty})"
      end
      puts "   -------------"
      puts "   TOTAL: #{profile.average_difficulty_per_day}"
      puts ""
    end
  end

  private

  def parse_chores!
    filename = "chores.txt"
    text = File.open(filename, 'rb') { |f| f.read }
    res = Chore.parse text, filename
    if res.ok?
      @chores = res.result
    else
      STDERR.puts "Error: #{res.error}"
      exit 1
    end
  end

  def parse_doers!
    filename = "doers.txt"
    text = File.open(filename, 'rb') { |f| f.read }
    res = Doer.parse text, filename
    if res.ok?
      @doers = res.result
    else
      STDERR.puts "Error: #{res.error}"
      exit 1
    end
  end
end

