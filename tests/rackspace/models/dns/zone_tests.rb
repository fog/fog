Shindo.tests('Fog::Rackspace::DNS | zone', ['rackspace']) do
  pending if Fog.mocking?

  provider = Fog::DNS[:rackspace]
  domain_name = uniq_id + '.com'

  zone = provider.zones.create({:domain => domain_name, :email => 'hostmaster@' + domain_name})

  tests('adding same domain twice throws error').raises(Fog::DNS::Rackspace::CallbackError) do
    provider.zones.create({:domain => domain_name, :email => 'hostmaster@' + domain_name})
  end

  zone.destroy
end
