Shindo.tests("Fog::Joyent[:analytics] | types", %w{joyent}) do
  @analytics = Fog::Joyent[:analytics]
  @types = @analytics.types

  tests('#all').succeeds do
    @types.all
  end

  tests('#new').succeeds do
    @types.new(['string', {'arity' => 'discrete', 'unit' => ''}])
  end

end
