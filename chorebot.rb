#!/usr/bin/ruby -w

$:.unshift File.dirname(__FILE__)

require 'optparse'
require 'result'
require 'chore'
require 'doer'

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


subtext = <<HELP
COMMAND may be:
  list-chores:    List defined chores
  list-doers:     List defined doers
HELP

global = OptionParser.new do |opts|
  opts.banner = "Usage: chorebot COMMAND [options]"
  opts.separator ""
  opts.separator subtext
end

bot = ChoreBot.new

subcommands = {
  "list-chores" => lambda { OptionParser.new do |opts|
                              opts.banner = "Usage: chorebot list-chores [options]"
                              opts.on("-h", "--help", "Show this message") do
                                puts opts
                                exit
                              end

                              bot.list_chores
                            end },

  "list-doers"  => lambda { OptionParser.new do |opts|
                              opts.banner = "Usage: chorebot list-doers [options]"
                              opts.on("-h", "--help", "Show this message") do
                                puts opts
                                exit
                              end

                              bot.list_doers
                            end }
}

global.order!
command = ARGV.shift

if subcommands[command]
  subcommands[command].call.order!
else
  puts global
end
