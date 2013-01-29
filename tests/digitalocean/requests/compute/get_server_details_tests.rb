Shindo.tests('Fog::Compute[:digitalocean] | get_server_details request', ['digitalocean', 'compute']) do

  tests('success') do

    test('#get_server_details') do
      Fog::Compute[:digitalocean].get_server_details(nil).body.is_a? Hash
    end

  end

end
