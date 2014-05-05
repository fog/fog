Shindo.tests("Fog::Joyent[:analytics] | field", %w{joyent}) do
  @analytics = Fog::Joyent[:analytics]
  @field = @analytics.fields.first

  tests('read only') do
    returns(false, 'should not save') { @field.respond_to?(:save)}
    returns(false, 'should not allow creating a new one') { @field.respond_to?(:create)}
    returns(false, 'should not allow destroying') { @field.respond_to?(:destroy)}
  end
end
