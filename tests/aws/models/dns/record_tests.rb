Shindo.tests("Fog::Dns[:aws] | record", ['aws', 'dns']) do

  pending if Fog.mocking?
  tests("zones#create").succeeds do
    @zone = Fog::DNS[:aws].zones.create(:domain => generate_unique_domain)
  end

  params = { :name => @zone.domain, :type => 'A', :ttl => 3600, :value => ['1.2.3.4'] }
  model_tests(@zone.records, params, false)

  tests("zones#destroy").succeeds do
    @zone.destroy
  end

end

