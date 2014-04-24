Shindo.tests("Fog::Compute[:google] | region model", ['google']) do
  @regions = Fog::Compute[:google].regions

  tests('success') do
    tests('#up').succeeds do
      region = @regions.get @regions.all.first.name
      region.up?
    end
  end
end
