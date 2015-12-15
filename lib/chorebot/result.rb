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
