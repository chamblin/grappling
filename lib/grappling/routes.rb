require 'securerandom'
require 'grappling/pd-json'
require 'logger'

log = Logger.new(STDOUT)

get "/" do
  @name = GrapplingConfiguration.instance.name
  erb :index
end

post "/" do
  begin
    body = request.body.read
    log.debug(body)
    PDJSON::Webhook.new(body).messages.each do |message|
      Resque.enqueue(GrapplingJob, message.to_json)
      log.info("Enqueued: " + message.to_json.inspect)
    end
  rescue
    halt 500
  end

  halt 200
end

