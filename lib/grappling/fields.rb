class GrapplingFields
  attr_reader :fields
  include Singleton

  def initialize
    @fields = []
  end

  def go(&block)
    self.instance_eval(&block)
  end

  def textfield(field)
    @fields << {:type => "text", :name => field}
  end

  def choice(field_name, choices)
    @fields << {:type => "select", :name => field_name, :choices => choices}
  end
end