Shindo.tests('Fog::Rackspace::DNS | zones', ['rackspace']) do

  provider = Fog::DNS[:rackspace]
  domain_sld = uniq_id
  domain_name = domain_sld + '.com'

  begin
    unless Fog.mocking?
      zone = provider.zones.create({:domain => domain_name, :email => "hostmaster@#{domain_name}"})
    end

    tests("zones.find(#{domain_sld}) => finds domain_name") do
      pending if Fog.mocking?
      returns(true) { provider.zones.all.any? {|z| z.domain == domain_name} }
    end

    random_name = uniq_id
    tests("zones.find(#{random_name}) => finds nothing") do
      pending if Fog.mocking?
      returns(false) { provider.zones.all.any? {|z| z.domain == random_name} }
    end
  ensure
    zone.destroy unless Fog.mocking?
  end

  tests('next_params') do
    zones = Fog::DNS::Rackspace::Zones.new
    returns(nil, "no body") { zones.send(:next_params, nil)}
    returns(nil, "no links") { zones.send(:next_params, {}) }
    returns(nil, "links are empty") { zones.send(:next_params, {'links' => []}) }
    returns(nil, "links does not contain next hash") { zones.send(:next_params, {'links' => [ {'rel' => 'previous'} ] }) }
    returns(nil, "contains a link without parameters") { zones.send(:next_params, {'links' => [ {'rel' => 'next', 'href' => "http://localhost/next"} ] }) }
    returns({"offset"=>["3"], "limit"=>["3"]}, "contains a link without parameters") { zones.send(:next_params, {'links' => [ {'rel' => 'next', 'href' => "http://localhost/next?offset=3&limit=3"} ] }) }
  end

end
