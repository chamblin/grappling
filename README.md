#What

_DSL - A domain specific language, where code is written in one language and errors are given in another. --[The Devil's Dictionary of Programming](http://programmingisterrible.com/post/65781074112/devils-dictionary-of-programming)_

Grappling is a tiny, hacky DSL for inflatable Webhooks for Ruby and [PagerDuty](http://www.pagerduty.com/).  It uses [Sinatra](http://www.sinatrarb.com/), [Resque](https://github.com/resque/resque), and [Bootstrap](http://getbootstrap.com/).  Bring your own Redis install, or just get a free one from [redis to go](http://www.redistogo.com/).

It is pretty OK for quick prototypes, one-off servers, and PagerDuty's hack days.

#Install

    gem install grappling

#Example

    # example.rb
    require 'grappling'
    
    redis_url "redis://redistogo:password@whatever.redistogo.com:12345/"
    name "Grappling Example"

    grapple do
        if is_trigger?
          # do something interesting here
        end
    end

Then just run

    grapple go example.rb

to start a webserver, and

    grapple do example.rb

To run a queue worker

##The Worker

###is\_trigger?, is\_acknowledge?, is\_resolve?, is\_unacknowledge?, is\_assign?, is\_escalate?, is\_delegate?

Predicates of the message that let you know the trigger type.

###description

The message's description

###user

`user` is a hash that contains stuff related to the assigned\_to (or, as appropriate the resolved\_by).  `:email` and `:name` are two useful fields in this hash.

###message

A hash version of the Webhook message sent by PagerDuty.


##Helper and Configuration Methods
###redis_url

redis_url configures the URL where Redis is set up, along with authentication details.  e.g. redis://username:password@host:port/.  The username is ignored because Redis doesn't support usernames.

###name

The application's name.  It's important and should be unique on the redis url you use.


#Heroku

Setting up a Grappling application on Heroku is super easy.  Mostly, you just follow these [notes](https://devcenter.heroku.com/articles/getting-started-with-ruby).  Notable differences:

You need `gem 'grappling'`, not `gem 'sinatra'` in your Gemfile.

Add `set port, ENV["PORT"]` to your application file.

Your Procfile should look like:

    web: bundle exec grapple go my_application.rb
    worker: bundle exec grapple do my_application.rb

#Other Random Notes

##JSON Handling

PagerDuty collapses a bunch of events into a single Webhook call.  We split them back out and make a task for each message.

##To rebuild the gem

    gem build grappling.gemspec
    gem install grappling-[version].gem

##Use ssh port forwarding to expose your development endpoint

For hack days, this is how I prefer to work instead of actually hosting this somewhere.  This sets up a tunnel so host:8888 forwards to localhost:4567

    ssh -R *:8888:localhost:4567 username@host

##Change the default port

In development mode, Grappling runs on port 4567 (this is just Sinatra after all).  You can change this, or any other Sinatra option, as follows:

    set :port, 80