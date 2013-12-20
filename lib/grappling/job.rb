require 'grappling/pd-json'
require 'grappling/routes'
require 'grappling/configuration'

class GrapplingJob

  @queue = :default

  def initialize(body)
    @hook = PDJSON::Message.new(body)
  end

  def go!
    instance_eval(&@@HOW_I_DO_IT)
  end

  def self.set_me_up(&block)
    @@HOW_I_DO_IT = block
  end

  def self.perform(body)
    self.new(body).go!
  end

  %w{acknowledge resolve trigger unacknowledge assign escalate delegate}.each do |type|
    method_name = "is_#{type}?"
    define_method(method_name) { @hook.send(method_name)}
  end

  %w{description user}.each do |method_name|
    define_method(method_name) { @hook.send(method_name) }
  end

  def message
    @hook.to_h
  end
end