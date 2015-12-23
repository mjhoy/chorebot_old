require 'chorebot/doer'
require 'chorebot/chore'

module TestHelper
  def jane_doe
    @_jane_doe ||= Doer.parse(<<TEXT, "testing").result[0]
Jane Doe <jane@jane.com>
TEXT
  end

  def chores
    @_chores ||= Chore.parse(<<TEXT, "testing").result
Scrub tub: 1 Medium

Clean fridge: 2 Hard
TEXT
  end

  def scrub_tub; chores[0]; end
  def clean_fridge; chores[1]; end
end
