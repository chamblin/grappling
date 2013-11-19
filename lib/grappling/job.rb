require 'grappling/pd-json'
require 'grappling/routes'
require 'grappling/configuration'

class GrapplingJob

  @queue = :default
  include GrapplingHelpers

  def initialize(hook_id, body)
    @endpoint_id = hook_id
    @endpoint_params = find_hook_settings(@endpoint_id)

    @hook = PDJSON::Message.new(body)

    configure_field_variables!
  end

  def go!
    instance_eval(&@@HOW_I_DO_IT)
  end

  def self.set_me_up(&block)
    @@HOW_I_DO_IT = block
  end

  def self.perform(hook_id, body)
    self.new(hook_id, body).go!
  end

  def is_acknowledge?
    @hook.is_acknowledge?
  end

  def is_resolve?
    @hook.is_resolve?
  end

  def is_trigger?
    @hook.is_trigger?
  end

  def description
    @hook.description
  end

  def user
    @hook.user
  end

  def json
    @hook.to_h
  end

  private
    def configure_field_variables!
      @endpoint_params.keys.each do |k|
        instance_variable_set("@%s" % k, @endpoint_params[k])
      end
    end


end