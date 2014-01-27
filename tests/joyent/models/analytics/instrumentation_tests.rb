Shindo.tests("Fog::Joyent[:analytics] | instrumentation", %w{joyent }) do
  model_tests(Fog::Joyent[:analytics].instrumentations, {:joyent_module => 'cpu', :stat => 'usage'}, true)

  @analytics = Fog::Joyent[:analytics]
  @instrumentation = @analytics.instrumentations.first

  tests('#values') do
    @values = @instrumentation.values(Time.now.utc.to_i - 600, 5)

    returns(Array) { @values.class }
    returns(Fog::Joyent::Analytics::Value) { @values.first.class }
  end
end
