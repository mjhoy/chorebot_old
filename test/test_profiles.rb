require 'minitest/autorun'
require 'date'

require 'chorebot/assignment'
require 'chorebot/profile'
require 'helper'

class ProfileTest < Minitest::Unit::TestCase

  include TestHelper

  def test_difficulty_per_day
    current_date = Date.new(2009, 10, 10)

    assignments = [
      # jane scrubbed the tub last week
      Assignment.new(jane_doe, scrub_tub, scrub_tub.difficulty, (current_date - 7))
    ]

    profile = Profile.new jane_doe, assignments, current_date

    assert_equal(
      scrub_tub.difficulty.to_f / 8, # not 7 to account for the same day
      profile.average_difficulty_per_day
    )
  end

  def test_difficulty_per_day_with_earlier_chores
    current_date = Date.new(2009, 10, 10)

    assignments = [
      Assignment.new(jane_doe, scrub_tub, scrub_tub.difficulty, (current_date - 7)),
      Assignment.new(jane_doe, clean_fridge, clean_fridge.difficulty, (current_date - 14))
    ]

    profile = Profile.new jane_doe, assignments, current_date

    assert_equal(
      (scrub_tub.difficulty.to_f + clean_fridge.difficulty) / 15,
      profile.average_difficulty_per_day
    )

    assignments = assignments.reverse

    profile2 = Profile.new jane_doe, assignments, current_date

    assert_equal(
      profile.average_difficulty_per_day,
      profile2.average_difficulty_per_day
    )
  end

  def test_diff_per_day_is_0_for_no_assignments
    current_date = Date.new(2009, 10, 10)

    assignments = []

    profile = Profile.new jane_doe, assignments, current_date

    assert_equal 0, profile.average_difficulty_per_day
  end

  def test_most_recent_chores_single
    current_date = Date.new(2009, 10, 10)

    assignments = [
      Assignment.new(jane_doe, scrub_tub, scrub_tub.difficulty, (current_date - 7)),
      Assignment.new(jane_doe, clean_fridge, clean_fridge.difficulty, (current_date - 14))
    ]

    profile = Profile.new jane_doe, assignments, current_date

    assert_equal(
      [scrub_tub],
      profile.most_recent_chores
    )
  end

  def test_most_recent_chores_multiple
    current_date = Date.new(2009, 10, 10)

    assignments = [
      Assignment.new(jane_doe, scrub_tub, scrub_tub.difficulty, (current_date - 7)),
      Assignment.new(jane_doe, clean_fridge, clean_fridge.difficulty, (current_date - 14)),
      Assignment.new(jane_doe, clean_fridge, clean_fridge.difficulty, (current_date - 7)),
    ]

    profile = Profile.new jane_doe, assignments, current_date

    assert_equal(
      [scrub_tub, clean_fridge].sort,
      profile.most_recent_chores
    )
  end
end
