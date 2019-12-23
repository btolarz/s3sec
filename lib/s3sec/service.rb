class Service
  def self.call(*args)
    new.call(*args)
  end
  
  def call
    raise(
      NotImplementedError,
      "#{self.class}##{__method__} must be implemented"
    )
  end
end
