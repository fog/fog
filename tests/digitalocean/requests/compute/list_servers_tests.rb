Shindo.tests('Fog::Compute[:digitalocean] | list_servers request', ['digitalocean', 'compute']) do

  tests('success') do

    test('#list_servers') do
      Fog::Compute[:digitalocean].list_servers.body.is_a? Hash
    end

  end

end
