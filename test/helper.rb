require 'chorebot/doer'
require 'chorebot/chore'

module TestHelper
  def test_doers
    @_doers ||= Doer.parse(<<TEXT, "testing").result
Jane Doe <jane@jane.com>

Randal Peltzer <randal@yahoo.com>

Mogwai <mogwai@yahoo.com>
TEXT
  end

  def jane_doe; test_doers[0]; end
  def randall; test_doers[1]; end
  def mogwai; test_doers[2]; end

  def test_chores
    @_chores ||= Chore.parse(<<TEXT, "testing").result
Scrub tub: 1 Medium

Clean fridge: 2 Hard
TEXT
  end

  def scrub_tub; test_chores[0]; end
  def clean_fridge; test_chores[1]; end
end
