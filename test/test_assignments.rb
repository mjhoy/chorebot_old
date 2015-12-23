require 'minitest/autorun'
require 'chorebot/assignment'

require 'helper'

class AssignmentTest < Minitest::Unit::TestCase
  include TestHelper

  def current_date
    Date.new(2009, 10, 10)
  end

  def test_simple_assignment
    assignment =
      # jane scrubbed the tub last week
      Assignment.new(jane_doe, scrub_tub, scrub_tub.difficulty, (current_date - 7))

    assert assignment.doer == jane_doe
    assert assignment.chore == scrub_tub
  end

  def test_string_output
    assignment = Assignment.new(jane_doe, scrub_tub, scrub_tub.difficulty, (current_date - 7))

    assert_equal <<TEXT, assignment.to_s
[#{ (current_date - 7).to_s }]
Chore: #{ scrub_tub.title } (#{scrub_tub.difficulty})
Doer: #{ jane_doe.heading_string }
TEXT

    assert_equal <<TEXT, assignment.to_string_without_date
Chore: #{ scrub_tub.title } (#{scrub_tub.difficulty})
Doer: #{ jane_doe.heading_string }
TEXT
  end

  def test_parses_string
    string = <<TEXT
# the assignment history.
# comments beginning with (#) should be ignored.


== 2015/12/22

Chore: Scrub tub (1)
Doer: Jane Doe <jane@jane.com>


== 2015/12/21

Chore: Clean fridge (2)
Doer: Randal Peltzer <randal@yahoo.com>

Chore: Scrub tub (1)
Doer: Jane Doe <jane@jane.com>

TEXT
    res = Assignment.parse string, "testing", test_chores, test_doers

    assert res.ok?, "correctly parsed result"

    results = res.result
    assert_equal 3, results.length

    assert_equal scrub_tub, results[0].chore
    assert_equal jane_doe, results[0].doer
    assert_equal Date.new(2015, 12, 22), results[0].date

    assert_equal Date.new(2015, 12, 21), results[1].date
    assert_equal results[1].date, results[2].date

    assert_equal randall, results[1].doer
  end
end
