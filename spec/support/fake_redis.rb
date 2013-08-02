class FakeRedis < Hash
  def initialize
    super
    @keys_to_expire = []
  end

  def expire(key, ttl)
    @keys_to_expire << key
  end

  def expire!
    @keys_to_expire.each { |key| delete(key) }
    @keys_to_expire = []
  end

  def dbsize
    keys.size
  end

  def del(*keys)
    keys.each do |key|
      delete(key)
    end
  end
end
