Shindo.tests("Fog::Joyent[:analytics] | type", %w{joyent}) do
  @analytics = Fog::Joyent[:analytics]
  @type = @analytics.types.first

  tests('read only') do
    returns(false, 'should not save') { @type.respond_to?(:save)}
    returns(false, 'should not allow creating a new one') { @type.respond_to?(:create)}
    returns(false, 'should not allow destroying') { @type.respond_to?(:destroy)}
  end
end
