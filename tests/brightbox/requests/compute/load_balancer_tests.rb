Shindo.tests('Fog::Compute[:brightbox] | load balancer requests', ['brightbox']) do

  tests('success') do

    unless Fog.mocking?
      @node = Brightbox::Compute::TestSupport.get_test_server
      node_id = @node.id
    end

    create_options = {
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

    tests("#create_load_balancer(#{create_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].create_load_balancer(create_options)
      @load_balancer_id = result["id"]
      formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER) { result }
    end

    unless Fog.mocking?
      Fog::Compute[:brightbox].load_balancers.get(@load_balancer_id).wait_for { ready? }
    end

    tests("#list_load_balancers()") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_load_balancers
      formats(Brightbox::Compute::Formats::Collection::LOAD_BALANCERS) { result }
    end

    tests("#get_load_balancer('#{@load_balancer_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_load_balancer(@load_balancer_id)
      formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER) { result }
    end

    tests("#destroy_load_balancer('#{@load_balancer_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].destroy_load_balancer(@load_balancer_id)
      formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER) { result }
    end

    unless Fog.mocking?
      @node.destroy
    end

  end

  tests('failure') do

    tests("#create_load_balancer").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].create_load_balancer
    end

    tests("#get_load_balancer('lba-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_load_balancer('lba-00000')
    end

    tests("#get_load_balancer").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_load_balancer
    end
  end

end
