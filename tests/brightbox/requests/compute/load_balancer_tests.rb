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
      formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER, false) { result }
    end

    unless Fog.mocking?
      Fog::Compute[:brightbox].load_balancers.get(@load_balancer_id).wait_for { ready? }
    end

    tests("#list_load_balancers()") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_load_balancers
      formats(Brightbox::Compute::Formats::Collection::LOAD_BALANCERS, false) { result }
    end

    tests("#get_load_balancer('#{@load_balancer_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_load_balancer(@load_balancer_id)
      formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER, false) { result }
    end

    update_options = {:name => "New name"}
    tests("#update_load_balancer('#{@load_balancer_id}', #{update_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].update_load_balancer(@load_balancer_id, update_options)
      formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER, false) { result }
    end

    add_listeners_options = {:listeners=>[{:out=>28080, :in=>8080, :protocol=>"http"}]}
    tests("#add_listeners_load_balancer('#{@load_balancer_id}', #{add_listeners_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].add_listeners_load_balancer(@load_balancer_id, add_listeners_options)
      formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER, false) { result }
    end

    remove_listeners_options = {:listeners=>[{:out=>28080, :in=>8080, :protocol=>"http"}]}
    tests("#remove_listeners_load_balancer('#{@load_balancer_id}', #{remove_listeners_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].remove_listeners_load_balancer(@load_balancer_id, remove_listeners_options)
      formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER, false) { result }
    end

    unless Fog.mocking?
      @node2 = Brightbox::Compute::TestSupport.get_test_server
      second_node_id = @node2.id
    end

    # Can't remove the last node so we need to add a second...
    add_nodes_options = {:nodes => [{:node => second_node_id}]}
    tests("#add_nodes_load_balancer('#{@load_balancer_id}', #{add_nodes_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].add_nodes_load_balancer(@load_balancer_id, add_nodes_options)
      formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER, false) { result }
    end

    # ...before we can attempt to remove either
    remove_nodes_options = {:nodes => [{:node => node_id}]}
    tests("#remove_nodes_load_balancer('#{@load_balancer_id}', #{remove_nodes_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].remove_nodes_load_balancer(@load_balancer_id, remove_nodes_options)
      formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER, false) { result }
    end

    tests("#destroy_load_balancer('#{@load_balancer_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].destroy_load_balancer(@load_balancer_id)
      formats(Brightbox::Compute::Formats::Full::LOAD_BALANCER, false) { result }
    end

    unless Fog.mocking?
      @node.destroy
      @node2.destroy
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
