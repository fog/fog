Shindo.tests('AWS::Elasticache | cache cluster requests', ['aws', 'elasticache']) do

  tests('success') do
    pending if Fog.mocking?

    # Randomize the cluster ID so tests can be fequently re-run
    cluster_id = "fog-test-cluster-#{rand(999).to_s}" # 20 chars max!

    tests(
    '#create_cache_cluster'
    ).formats(AWS::Elasticache::Formats::SINGLE_CACHE_CLUSTER) do
      body = AWS[:elasticache].create_cache_cluster(cluster_id).body
      cluster = body['CacheCluster']
      returns(cluster_id) { cluster['CacheClusterId'] }
      returns('creating') { cluster['CacheClusterStatus'] }
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
      body = AWS[:elasticache].describe_cache_clusters(cluster_id).body
      returns(1, "size of 1") { body['CacheClusters'].size }
      returns(cluster_id, "has #{cluster_id}") do
        body['CacheClusters'].first['CacheClusterId']
      end
      body
    end

    Formatador.display_line "Waiting for cluster #{cluster_id}..."
    AWS[:elasticache].clusters.get(cluster_id).wait_for {ready?}

    tests(
    '#modify_cache_cluster - change a non-pending cluster attribute'
    ).formats(AWS::Elasticache::Formats::CACHE_CLUSTER_RUNNING) do
      body = AWS[:elasticache].modify_cache_cluster(cluster_id,
        :auto_minor_version_upgrade => false
      ).body
      # now check that parameter change is in place
      returns('false')  { body['CacheCluster']['AutoMinorVersionUpgrade'] }
      body['CacheCluster']
    end

    tests(
    '#modify_cache_cluster - change a pending cluster attribute'
    ).formats(AWS::Elasticache::Formats::CACHE_CLUSTER_RUNNING) do
      body = AWS[:elasticache].modify_cache_cluster(cluster_id,
        :auto_minor_version_upgrade => false
      ).body
      # now check that parameter change is in place
      returns('false')  { body['CacheCluster']['AutoMinorVersionUpgrade'] }
      body['CacheCluster']
    end

    tests(
    '#delete_cache_clusters'
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
