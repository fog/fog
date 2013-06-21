Shindo.tests('Fog::Rackspace::DNS | zones', ['rackspace']) do
  pending if Fog.mocking?

  provider = Fog::DNS[:rackspace]
  domain_sld = uniq_id
  domain_name = domain_sld + '.com'

  begin
    zone = provider.zones.create({:domain => domain_name, :email => "hostmaster@#{domain_name}"})

    tests("zones.find(#{domain_sld}) => finds domain_name") do
      returns(false) { provider.zones.find { |z| z.domain =~ /#{domain_sld}/}.nil? }
    end

    random_name = uniq_id
    tests("zones.find(#{random_name}) => finds nothing") do
      returns(true) { provider.zones.find{ |z| z.domain =~ /#{random_name}/ }.nil? }
    end
  ensure
    zone.destroy
  end
end
