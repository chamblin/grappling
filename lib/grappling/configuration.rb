require 'redis'

class GrapplingConfiguration
  include Singleton
  attr_accessor :redis_url, :name

  def redis
    uri = URI.parse(redis_url)
    Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
  end
end