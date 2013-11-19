require 'sinatra'
require 'singleton'
require 'grappling/fields'
require 'grappling/configuration'
require 'grappling/job'
require 'grappling/routes'
require 'resque'

# things that grappling users actually use

def fields(&block)
  GrapplingFields.instance.go(&block)
end

def grapple(&block)
  GrapplingJob.set_me_up(&block)
end

def redis_url(url)
  GrapplingConfiguration.instance.redis_url = url
  Resque.redis = GrapplingConfiguration.instance.redis
end

def name(n)
  GrapplingConfiguration.instance.name = n
end

# override the views and public directory to refer to the gem's directory

set :views, Proc.new{ File.join(File.dirname(__FILE__), "..", "assets", "views") }
set :public, Proc.new{ File.join(File.dirname(__FILE__), "..", "assets", "public") }