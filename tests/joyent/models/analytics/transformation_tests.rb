Shindo.tests("Fog::Joyent[:analytics] | transformation", %w{joyent}) do
  @analytics = Fog::Joyent[:analytics]
  @transformation = @analytics.transformations.first

  tests('read only') do
    returns(false, 'should not save') { @transformation.respond_to?(:save)}
    returns(false, 'should not allow creating a new one') { @transformation.respond_to?(:create)}
    returns(false, 'should not allow destroying') { @transformation.respond_to?(:destroy)}
  end
end
