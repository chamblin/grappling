Gem::Specification.new do |s|
  s.name        = 'grappling'
  s.version     = '0.0.1'
  s.date        = '2013-11-08'
  s.summary     = "Grappling"
  s.description = "Hacky webhook applications for PagerDuty!"
  s.authors     = ["Cory Chamblin"]
  s.email       = 'c@pagerduty.com'
  s.files       = ["lib/grappling.rb"] +
                  Dir.glob("lib/grappling/*.rb") +
                  Dir.glob("assets/*/*") +
                  Dir.glob("assets/public/*/*")
  s.homepage    = 'http://github.com/chamblin/grappling'
  s.license       = 'MIT'
  s.add_runtime_dependency "sinatra", ["= 1.1.0"]
  s.add_runtime_dependency "redis"
  s.add_runtime_dependency "resque", "~> 1.25.1"
  s.executables << 'grapple'
end