Shindo.tests("Fog::Joyent[:analytics] | metric", %w{joyent}) do
  @analytics = Fog::Joyent[:analytics]
  @metric = @analytics.metrics.first

  tests('read only') do
    returns(false, 'should not save') { @metric.respond_to?(:save)}
    returns(false, 'should not allow creating a new one') { @metric.respond_to?(:create)}
    returns(false, 'should not allow destroying') { @metric.respond_to?(:destroy)}
  end
end
