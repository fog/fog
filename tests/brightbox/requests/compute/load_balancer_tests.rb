Shindo.tests('Brightbox::Compute | load balancer requests', ['brightbox']) do

  tests('success') do

    node_id = Brightbox[:compute].list_servers.first["id"]

    creation_args = {
      :nodes => [{
        :node => node_id
      }],
      :listeners => [{
        :in       => 80,
        :out      => 8080,
        :protocol => "http"
      }],
      :healthcheck => {
        :type => "http",
        :port => 80
      }
    }

    tests("#create_load_balancer(#{creation_args.inspect})").formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER) do
      data = Brightbox[:compute].create_load_balancer(creation_args)
      @load_balancer_id = data["id"]
      data
    end

    # tests("#list_load_balancers()").formats(Brightbox::Compute::Formats::Collection::LOAD_BALANCERS) do
    #   Brightbox[:compute].list_load_balancers
    # end

    tests("#get_load_balancer('#{@load_balancer_id}')").formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER) do
      Brightbox[:compute].get_load_balancer(@load_balancer_id)
    end

    # May fail since the load balancer is likely to still be "creating" when this test is called
    # tests("#destroy_load_balancer('#{@load_balancer_id}')").formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER) do
    #   Brightbox[:compute].destroy_load_balancer(@load_balancer_id)
    # end

  end

  tests('failure') do

    tests("#create_load_balancer()").raises(Excon::Errors::BadRequest) do
      Brightbox[:compute].create_load_balancer()
    end

    tests("#get_load_balancer('lba-00000')").raises(Excon::Errors::NotFound) do
      Brightbox[:compute].get_load_balancer('lba-00000')
    end

    tests("#get_load_balancer()").raises(ArgumentError) do
      Brightbox[:compute].get_load_balancer()
    end
  end

end
