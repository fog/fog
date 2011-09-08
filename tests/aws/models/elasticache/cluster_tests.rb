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
    @instance.reload  # Reload to get the cluster info from AWS
    puts "Waiting for #{@instance.id} to become available (#{@instance.status})..."
    @instance.wait_for {ready?}
  end

  # Single model is still deleting, so re-randomize the cluster ID
  cluster_params[:id] = "fog-test-cluster-#{rand(999).to_s}"
  collection_tests(AWS[:elasticache].clusters, cluster_params, false) do
    @instance.reload  # Reload to get the cluster info from AWS
    puts "Waiting for #{@instance.id} to become available (#{@instance.status})..."
    @instance.wait_for {ready?}
  end

end
