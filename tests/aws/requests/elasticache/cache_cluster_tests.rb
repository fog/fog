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

    #cluster = AWS[:elasticache].clusters.get(cluster_id)
    #cluster.wait_for {ready?}
    #
    #tests(
    #'#delete_cache_security_group'
    #).formats(AWS::Elasticache::Formats::SINGLE_CACHE_CLUSTER) do
    #  body = AWS[:elasticache].delete_cache_security_group(cluster_id).body
    #cluster = body['CacheCluster']
    #returns(cluster_id) { cluster['CacheClusterId'] }
    #returns('deleting')  { cluster['CacheClusterStatus'] }
    #body
    #end
  end

  tests('failure') do
    # TODO:
    # Create a duplicate cluster ID
    # List a missing cache cluster
    # Delete a missing cache cluster
  end
end
