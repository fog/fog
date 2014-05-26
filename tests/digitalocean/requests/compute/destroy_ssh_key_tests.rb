Shindo.tests('Fog::Compute[:digitalocean] | destroy_ssh_key request', ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]

  tests('success') do

    test('#destroy_ssh_key') do
      key = service.create_ssh_key 'fookey', 'fookey'
      service.destroy_ssh_key(key.body['ssh_key']['id']).body['status'] == 'OK'
    end

  end

  tests('failures') do
    test 'delete invalid key' do
      # DigitalOcean API returns 500 with this sometimes
      # so mark it as pending in real mode
      pending unless Fog.mocking?
      service.destroy_ssh_key('00000000000').body['status'] == 'ERROR'
    end
  end

end
