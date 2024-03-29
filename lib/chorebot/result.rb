# A Result object represents a calculation that can succeed or fail.
#
# For a "successful" calculation, the status attribute must be set to
# :ok; all other values are assumed to be errors.
#
# Succesful calculations have a meaningful result
# attribute. Otherwise, the error attribute should be a string
# describing the error.
class Result
  attr_reader :status
  attr_reader :result
  attr_reader :error

  def initialize status, result = nil, error = ""
    @status = status
    @result = result
    @error = error
  end

  def self.ok result
    self.new :ok, result
  end

  def self.err error
    self.new :error, nil, error
  end

  def ok?
    self.status == :ok
  end
end
