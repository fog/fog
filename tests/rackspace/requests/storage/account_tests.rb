Shindo.tests('Fog::Storage[:rackspace] | account requests', ["rackspace"]) do

  tests('success') do

    tests("#post_set_meta_temp_url_key('super_secret_key')").succeeds do
      Fog::Storage[:rackspace].post_set_meta_temp_url_key('super_secret_key')
    end

  end

  tests('failure') do

  end

end
