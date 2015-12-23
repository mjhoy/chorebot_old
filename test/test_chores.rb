require 'minitest/autorun'

require 'chorebot/chore'

class TestChore < Minitest::Unit::TestCase
  def test_parse_simple
    text = <<TEXT
Scrub tub: 1 Medium
TEXT

    res = Chore.parse text, "testing"

    assert res.ok?, "result is good"

    assert res.result.length == 1, "1 chore"

    chore = res.result[0]

    assert chore.title == "Scrub tub",
           "title is parsed"
    assert chore.interval == 1,
           "interval is parsed"
    assert chore.difficulty == Chore::DIFFICULTY["medium"],
           "difficulty is parsed"

    refute chore.description
  end

  def test_parse_multiple
    text = <<TEXT
Scrub tub: 1 Medium
A description

Wash laundry: 1 Easy
TEXT

    res = Chore.parse text, "testing"

    assert res.ok?, "result is good"

    assert res.result.length == 2, "2 chores"

    chore = res.result[0]

    assert chore.title == "Scrub tub",
           "title is parsed"
    assert_equal "A description", chore.description
    chore2 = res.result[1]
    assert_equal "Wash laundry", chore2.title
  end

  def test_description
    text = <<TEXT
Scrub tub: 1 Medium
A description
Multiple lines
TEXT

    res = Chore.parse text, "testing"

    assert res.ok?, "result is good"
    chore = res.result[0]
    assert_equal "A description\nMultiple lines",
                 chore.description
  end

end
