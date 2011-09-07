Shindo.tests('AWS::Elasticache | cache cluster requests', ['aws', 'elasticache']) do

  tests('success') do
    pending if Fog.mocking?

    cluster_id = 'fog-test-cluster'

    tests(
    '#create_cache_cluster'
    ).formats(AWS::Elasticache::Formats::SINGLE_CACHE_CLUSTER) do
      body = AWS[:elasticache].create_cache_cluster(
        :cluster_id => cluster_id
      ).body
      cluster = body['CacheCluster']
      returns(cluster_id) { cluster['CacheClusterId'] }
      returns('creating')  { cluster['CacheClusterStatus'] }
      body
    end
    
    tests(
    '#describe_cache_clusters without options'
    ).formats(AWS::Elasticache::Formats::DESCRIBE_CACHE_CLUSTERS) do
      body = AWS[:elasticache].describe_cache_clusters.body
      returns(true, "has #{cluster_id}") do
        body['CacheClusters'].any? do |cluster|
          cluster['CacheClusterId'] == cluster_id
        end
      end
      # The DESCRIBE_CACHE_CLUSTERS format must include only one cluster
      # So remove all but the relevant cluster from the response body
      test_cluster = body['CacheClusters'].delete_if do |cluster|
        cluster['CacheClusterId'] != cluster_id
      end
      body
    end
    
    tests(
    '#describe_cache_clusters with cluster ID'
    ).formats(AWS::Elasticache::Formats::DESCRIBE_CACHE_CLUSTERS) do
      body = AWS[:elasticache].describe_cache_clusters(
        'CacheClusterId' => cluster_id
      ).body
      returns(1, "size of 1") { body['CacheClusters'].size }
      returns(cluster_id, "has #{cluster_id}") do
        body['CacheClusters'].first['CacheClusterId']
      end
      body
    end

    puts "Waiting for cluster #{cluster_id} to become available..."
    cluster = AWS[:elasticache].clusters.find {|c| c.id == cluster_id}
    #cluster.wait_for {ready?}    # This doesn't work (entity disappears)
    while (cluster.status != "available") do
      puts "Waiting for cluster #{cluster.id} (#{cluster.status})"
      sleep 20
      #cluster.reload             # This doesn't work either! (no changes)
      cluster = AWS[:elasticache].clusters.find {|c| c.id == cluster_id}
    end

    tests(
    '#delete_cache_security_group'
    ).formats(AWS::Elasticache::Formats::CACHE_CLUSTER_RUNNING) do
      body = AWS[:elasticache].delete_cache_cluster(cluster_id).body
      # make sure this particular cluster is in the returned list
      returns(true, "has #{cluster_id}") do
        body['CacheClusters'].any? do |cluster|
          cluster['CacheClusterId'] == cluster_id
        end
      end
      # now check that it reports itself as 'deleting'
      cluster = body['CacheClusters'].find do |cluster|
        cluster['CacheClusterId'] == cluster_id
      end
      returns('deleting')  { cluster['CacheClusterStatus'] }
      cluster
    end
  end

  tests('failure') do
    # TODO:
    # Create a duplicate cluster ID
    # List a missing cache cluster
    # Delete a missing cache cluster
  end
end
