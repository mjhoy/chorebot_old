require 'minitest/autorun'

require 'chorebot/doer'

class DoerTest < Minitest::Test

  def test_simple_parse
    text = <<TEXT
Mikey Hoy <mjh@mjhoy.com>
TEXT

    res = Doer.parse text, "testing"

    assert res.ok?

    assert_equal 1, res.result.length

    doer = res.result[0]
    assert_equal "Mikey Hoy", doer.name
    assert_equal "mjh@mjhoy.com", doer.email

    assert_equal "Mikey Hoy <mjh@mjhoy.com>", doer.heading_string
  end
end
