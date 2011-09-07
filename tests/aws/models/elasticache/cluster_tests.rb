Shindo.tests('AWS::Elasticache | cache clusters', ['aws', 'elasticache']) do
  cluster_params = {
    :id               => 'fog-test-cluster',
    :node_type        => 'cache.m1.large',
    :security_groups  => ['default'],
    :engine           => 'memcached',
    :num_nodes        => 1
  }

  pending if Fog.mocking?

  model_tests(AWS[:elasticache].clusters, cluster_params, false) do
    # Reload to get the cluster info
    @instance.reload
    puts "Waiting for cluster #{@instance.id} to become available..."
    #@instance.wait_for {ready?}    # This doesn't work (entity disappears)
    while (@instance.status != "available") do
      puts "Waiting for cluster #{@instance.id} (#{@instance.status})"
      sleep 20
      #@instance.reload             # This doesn't work either! (no changes)
      @instance = AWS[:elasticache].clusters.find {|c| c.id == @instance.id}
    end
  end

  collection_tests(AWS[:elasticache].clusters, cluster_params, false) do
    # Reload to get the cluster info
    @instance.reload
    puts "Waiting for cluster #{@instance.id} to become available..."
    #@instance.wait_for {ready?}    # This doesn't work (entity disappears)
    while (@instance.status != "available") do
      puts "Waiting for cluster #{@instance.id} (#{@instance.status})"
      sleep 20
      #@instance.reload             # This doesn't work either! (no changes)
      @instance = AWS[:elasticache].clusters.find {|c| c.id == @instance.id}
    end
  end

end
