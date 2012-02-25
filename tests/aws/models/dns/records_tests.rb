Shindo.tests("Fog::DNS[:aws] | records", ['aws', 'dns']) do

  pending if Fog.mocking?
  tests("zones#create").succeeds do
    @zone = Fog::DNS[:aws].zones.create(:domain => generate_unique_domain)
  end

  param_groups = [
    # A record
    { :name => @zone.domain, :type => 'A', :ttl => 3600, :value => ['1.2.3.4'] },
    # CNAME record
    { :name => "www.#{@zone.domain}", :type => "CNAME", :ttl => 300, :value => @zone.domain}
  ]

  param_groups.each do |params|
    collection_tests(@zone.records, params, false)
  end

  tests("zones#destroy").succeeds do
    @zone.destroy
  end
end

