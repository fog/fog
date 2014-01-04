Shindo.tests("Fog::Joyent[:analytics] | fields", %w{joyent}) do
  @analytics = Fog::Joyent[:analytics]
  @fields = @analytics.fields

  tests('#all').succeeds do
    @fields.all
  end

  tests('#new').succeeds do
    @fields.new(['apache', { 'label' => 'Apache', 'type' => 'string' }])
  end

end
