Shindo.tests("Fog::Joyent[:analytics] | joyent_modules", %w{joyent}) do
  @analytics = Fog::Joyent[:analytics]
  @joyent_modules = @analytics.joyent_modules

  tests('#all').succeeds do
    @joyent_modules.all
  end

  tests('#new').succeeds do
    @joyent_modules.new(['cpu', { 'label' => 'CPU' }])
  end

end
