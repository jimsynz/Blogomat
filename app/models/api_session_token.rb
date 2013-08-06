class ApiSessionToken
  extend  ActiveModel::Naming
  include ActiveModel::Serialization
  include JsonSerializingModel

  TTL = 20.minutes

  def initialize(existing_token=nil, redis=_redis_connection)
    @token = existing_token
    @redis = redis

    unless expired?
      self.last_seen = Time.now
    end
  end

  def token
    @token ||= MicroToken.generate 128
  end

  def ttl
    return 0 if @deleted
    return TTL unless last_seen
    elapsed   = Time.now - last_seen
    remaining = (TTL - elapsed).floor
    remaining > 0 ? remaining : 0
  end

  def last_seen
    @last_seen ||= _retrieve_last_seen
  end

  def last_seen=(as_at)
    _set_with_expire(_last_seen_key, as_at.iso8601)
    @last_seen = as_at
  end

  def user
    return if expired?
    @user ||= _retrieve_user
  end

  def user=(user)
    _set_with_expire(_user_id_key, user.id)
    @user = user
  end

  def expired?
    ttl < 1
  end

  def valid?
    !expired?
  end

  def deleted?
    @deleted
  end

  def delete!
    @redis.del(_last_seen_key, _user_id_key)
    @deleted = true
  end

  private

  def _set_with_expire(key,val)
    @redis[key] = val
    @redis.expire(key, TTL)
  end

  def _retrieve_last_seen
    ls = @redis[_last_seen_key]
    ls && Time.parse(ls)
  end

  def _retrieve_user
    user_id = @redis[_user_id_key]
    User.find(user_id) if user_id
  end

  def _last_seen_key
    "session_token/#{token}/last_seen"
  end

  def _user_id_key
    "session_token/#{token}/user_id"
  end

  def _redis_connection
    opts = {}
    opts[:driver] = :hiredis
    Redis.new opts
  end
end
