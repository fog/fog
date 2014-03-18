Shindo.tests("Fog::Joyent[:analytics] | metrics", %w{joyent}) do
  @analytics = Fog::Joyent[:analytics]
  @metrics = @analytics.metrics

  tests('#all').succeeds do
    @metrics.all
  end

  tests('#new').succeeds do
    @metrics.new({
                     "module" => "cpu",
                     "stat" => "thread_executions",
                     "label" => "thread executions",
                     "interval" => "interval",
                     "fields" => ["hostname", "zonename", "runtime"],
                     "unit" => "operations"
                 })
  end

end
