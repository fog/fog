Shindo.tests("Fog::Joyent[:analytics] | joyent_module", %w{joyent}) do
  @analytics = Fog::Joyent[:analytics]
  @joyent_module = @analytics.joyent_modules.first

  tests('read only') do
    returns(false, 'should not save') { @joyent_module.respond_to?(:save)}
    returns(false, 'should not allow creating a new one') { @joyent_module.respond_to?(:create)}
    returns(false, 'should not allow destroying') { @joyent_module.respond_to?(:destroy)}
  end
end
