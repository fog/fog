Shindo.tests("Fog::Joyent[:analytics] | transformations", %w{joyent}) do
  @analytics = Fog::Joyent[:analytics]
  @transformations = @analytics.transformations

  tests('#all').succeeds do
    @transformations.all
  end

  tests('#new').succeeds do
    @transformations.new(['geolocate', { 'label' => 'geolocate IP addresses', "fields" => ["raddr"] }])
  end

end
