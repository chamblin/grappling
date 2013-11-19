require 'securerandom'
require 'grappling/pd-json'

get "/" do
  @fields = GrapplingHelpers.user_fields
  @name = GrapplingConfiguration.instance.name
  erb :index
end

post "/c" do
  key = SecureRandom.hex # hopefully random enough

  fields = {}

  user_fields.each do |field|
    fields[field[:name]] = params[field[:name]]
  end

  GrapplingConfiguration.instance.redis.hmset(key, {"exists" => true}.merge(fields).to_a.flatten)

  @url = hook_url(key)
end

post "/h/:hook_id" do
  hook_settings = find_hook_settings(params[:hook_id])

  if hook_settings.nil?
    halt 404
  end

  begin
    PDJSON::Webhook.new(request.body.read).messages.each do |message|
      Resque.enqueue(GrapplingJob, params[:hook_id], message.to_json)
    end
  rescue
    halt 500
  end

  halt 200
end

module GrapplingHelpers
  def find_hook_settings(hook_id)
    result = GrapplingConfiguration.instance.redis.hgetall(hook_id)
    result.empty? ? nil : result
  end

  def user_fields
    GrapplingFields.instance.fields
  end

  def hook_url(hook_id)
    "%s/h/%s" % [request.base_url, hook_id]
  end
end

helpers GrapplingHelpers