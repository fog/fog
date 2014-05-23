require 'fog/rackspace/models/identity/service_catalog'

Shindo.tests('Fog::Rackspace::ServiceCatalog | users', ['rackspace']) do

    tests('successful') do
      before_hash = {"access"=>{"token"=>{"expires"=>"2013-02-20T10:31:00.000-06:00", "tenant"=>{"name"=>"777", "id"=>"777"}, "id"=>"6ca10877-7c50-4a5c-b58f-004d835c39c3"},
      "serviceCatalog"=>[{"type"=>"volume", "endpoints"=>[{"region"=>"DFW", "tenantId"=>"777", "publicURL"=>"https://dfw.blockstorage.api.rackspacecloud.com/v1/777"},
      {"region"=>"ORD", "tenantId"=>"777", "publicURL"=>"https://ord.blockstorage.api.rackspacecloud.com/v1/777"}], "name"=>"cloudBlockStorage"},
      {"type"=>"rax:load-balancer", "endpoints"=>[{"region"=>"ORD", "tenantId"=>"777", "publicURL"=>"https://ord.loadbalancers.api.rackspacecloud.com/v1.0/777"},
      {"region"=>"DFW", "tenantId"=>"777", "publicURL"=>"https://dfw.loadbalancers.api.rackspacecloud.com/v1.0/777"}], "name"=>"cloudLoadBalancers"},
      {"type"=>"object-store", "endpoints"=>[{"internalURL"=>"https://snet-storage101.dfw1.clouddrive.com/v1/Mosso777", "region"=>"DFW",
      "tenantId"=>"Mosso777",
      "publicURL"=>"https://storage101.dfw1.clouddrive.com/v1/Mosso777"},
      {"internalURL"=>"https://snet-storage101.ord1.clouddrive.com/v1/Mosso777", "region"=>"ORD",
      "tenantId"=>"Mosso777",
      "publicURL"=>"https://storage101.ord1.clouddrive.com/v1/Mosso777"}], "name"=>"cloudFiles"}, {"type"=>"rax:database",
      "endpoints"=>[{"region"=>"DFW", "tenantId"=>"777", "publicURL"=>"https://dfw.databases.api.rackspacecloud.com/v1.0/777"}, {"region"=>"ORD", "tenantId"=>"777",
      "publicURL"=>"https://ord.databases.api.rackspacecloud.com/v1.0/777"}], "name"=>"cloudDatabases"}, {"type"=>"rax:dns", "endpoints"=>[{"tenantId"=>"777",
      "publicURL"=>"https://dns.api.rackspacecloud.com/v1.0/777"}], "name"=>"cloudDNS"}, {"type"=>"compute", "endpoints"=>[{"versionId"=>"1.0", "tenantId"=>"777",
      "versionList"=>"https://servers.api.rackspacecloud.com/", "versionInfo"=>"https://servers.api.rackspacecloud.com/v1.0",
      "publicURL"=>"https://servers.api.rackspacecloud.com/v1.0/777"}], "name"=>"cloudServers"}, {"type"=>"compute", "endpoints"=>[{"region"=>"DFW", "versionId"=>"2",
      "tenantId"=>"777", "versionList"=>"https://dfw.servers.api.rackspacecloud.com/", "versionInfo"=>"https://dfw.servers.api.rackspacecloud.com/v2",
      "publicURL"=>"https://dfw.servers.api.rackspacecloud.com/v2/777"}, {"region"=>"ORD", "versionId"=>"2", "tenantId"=>"777",
      "versionList"=>"https://ord.servers.api.rackspacecloud.com/", "versionInfo"=>"https://ord.servers.api.rackspacecloud.com/v2",
      "publicURL"=>"https://ord.servers.api.rackspacecloud.com/v2/777"}, {"versionId"=>"2", "tenantId"=>"777", "versionList"=>"https://servers.api.rackspacecloud.com/", "versionInfo"=>"https://servers.api.rackspacecloud.com/v2", "publicURL"=>"https://servers.api.rackspacecloud.com/v2/777"}], "name"=>"cloudServersOpenStack"}, {"type"=>"rax:monitor", "endpoints"=>[{"tenantId"=>"777",
      "publicURL"=>"https://monitoring.api.rackspacecloud.com/v1.0/777"}], "name"=>"cloudMonitoring"}, {"type"=>"rax:object-cdn", "endpoints"=>[{"region"=>"DFW",
      "tenantId"=>"Mosso777", "publicURL"=>"https://cdn1.clouddrive.com/v1/Mosso777"},
      {"region"=>"ORD", "tenantId"=>"Mosso777",
      "publicURL"=>"https://cdn2.clouddrive.com/v1/Mosso777"}], "name"=>"cloudFilesCDN"},

      {"type"=>"not_here", "name" => "not_here", "endpoints"=>[{"tenantId"=>"777", "region" => "LON",
      "publicURL"=>"https://monitoring.api.rackspacecloud.com/v1.0/777"}]}
      ],

      "user"=>{"roles"=>[{"description"=>"User Admin
      Role.", "name"=>"identity:user-admin", "id"=>"3"}], "name"=>"joe-racker", "RAX-AUTH:defaultRegion"=>"", "id"=>"TK421"}}}

      @service_catalog = Fog::Rackspace::Identity::ServiceCatalog.from_response(nil, before_hash)
    end

    tests('services') do
      services = ["cloudBlockStorage", "cloudDNS", "cloudDatabases", "cloudFiles", "cloudFilesCDN", "cloudLoadBalancers", "cloudMonitoring", "cloudServers", "cloudServersOpenStack", "not_here"]

      returns(services) { @service_catalog.services.map {|s| s.to_s }.sort }
    end

  tests('get_endpoints') do
    endpoints = [{"region"=>"DFW", "versionId"=>"2", "tenantId"=>"777", "versionList"=>"https://dfw.servers.api.rackspacecloud.com/", "versionInfo"=>"https://dfw.servers.api.rackspacecloud.com/v2", "publicURL"=>"https://dfw.servers.api.rackspacecloud.com/v2/777"}, {"region"=>"ORD", "versionId"=>"2", "tenantId"=>"777", "versionList"=>"https://ord.servers.api.rackspacecloud.com/", "versionInfo"=>"https://ord.servers.api.rackspacecloud.com/v2", "publicURL"=>"https://ord.servers.api.rackspacecloud.com/v2/777"}, {"versionId"=>"2", "tenantId"=>"777", "versionList"=>"https://servers.api.rackspacecloud.com/", "versionInfo"=>"https://servers.api.rackspacecloud.com/v2", "publicURL"=>"https://servers.api.rackspacecloud.com/v2/777"}]
    returns(endpoints) { @service_catalog.get_endpoints(:cloudServersOpenStack) }
    returns(endpoints) { @service_catalog.get_endpoints('cloudServersOpenStack') }
    returns({}) { @service_catalog.get_endpoints('non-existent') }
  end

  tests('get_endpoint') do
    tests('service with mulitple endpoints') do
      returns("https://dfw.servers.api.rackspacecloud.com/v2/777") { @service_catalog.get_endpoint(:cloudServersOpenStack, :dfw) }
      returns("https://ord.servers.api.rackspacecloud.com/v2/777") { @service_catalog.get_endpoint(:cloudServersOpenStack, :ord) }
      returns("https://dfw.servers.api.rackspacecloud.com/v2/777") { @service_catalog.get_endpoint(:cloudServersOpenStack, 'dfw') }
      returns("https://dfw.servers.api.rackspacecloud.com/v2/777") { @service_catalog.get_endpoint('cloudServersOpenStack', 'dfw') }
      returns("https://servers.api.rackspacecloud.com/v2/777") { @service_catalog.get_endpoint('cloudServersOpenStack', :global) }
    end

    tests('with one endpoint') do
      tests('catalog contains global endpoint') do
        catalog_hash =  [{"type"=>"volume", "endpoints"=>[{"tenantId"=>"777", "publicURL"=>"https://blockstorage.api.rackspacecloud.com/v1/777"}], "name"=>"cloudBlockStorage"}]
        @service_catalog = Fog::Rackspace::Identity::ServiceCatalog.new(:service => nil, :catalog => catalog_hash)

        tests('no region specifed').returns("https://blockstorage.api.rackspacecloud.com/v1/777") do
          @service_catalog.get_endpoint(:cloudBlockStorage)
        end
        tests('region specifed').returns("https://blockstorage.api.rackspacecloud.com/v1/777") do
          @service_catalog.get_endpoint(:cloudBlockStorage, :ord)
        end
      end
      tests('catalog does not contain global endpoint') do
        catalog_hash =   [{"type"=>"volume", "endpoints"=>[{"region" => "ORD", "tenantId"=>"777", "publicURL"=>"https://ord.blockstorage.api.rackspacecloud.com/v1/777"}], "name"=>"cloudBlockStorage"}]
        @service_catalog = Fog::Rackspace::Identity::ServiceCatalog.new(:service => nil, :catalog => catalog_hash)

        tests('non-existing region') do
          raises(RuntimeError) { @service_catalog.get_endpoint(:cloudBlockStorage, :dfw) }
        end
        tests('existing region').returns("https://ord.blockstorage.api.rackspacecloud.com/v1/777") do
          @service_catalog.get_endpoint(:cloudBlockStorage, :ord)
        end
      end
    end

    tests('endpoint type') do
      catalog_hash =  [{"type"=>"object-store", "endpoints"=>[{"internalURL"=>"https://snet-storage101.dfw1.clouddrive.com/v1/Mosso777", "region"=>"DFW",
      "tenantId"=>"Mosso777",
      "publicURL"=>"https://storage101.dfw1.clouddrive.com/v1/Mosso777"},
      {"internalURL"=>"https://snet-storage101.ord1.clouddrive.com/v1/Mosso777", "region"=>"ORD",
      "tenantId"=>"Mosso777",
      "publicURL"=>"https://storage101.ord1.clouddrive.com/v1/Mosso777"}], "name"=>"cloudFiles"}]
      @service_catalog = Fog::Rackspace::Identity::ServiceCatalog.new(:service => nil, :catalog => catalog_hash)

      returns("https://storage101.ord1.clouddrive.com/v1/Mosso777") { @service_catalog.get_endpoint(:cloudFiles, :ord) }
      returns("https://snet-storage101.ord1.clouddrive.com/v1/Mosso777") { @service_catalog.get_endpoint(:cloudFiles, :ord, true) }
      returns("https://storage101.ord1.clouddrive.com/v1/Mosso777") { @service_catalog.get_endpoint(:cloudFiles, :ord, false) }
    end

    tests('error conditions') do
      raises(RuntimeError) { @service_catalog.get_endpoint(:cloudServersOpenStack) }
      raises(RuntimeError) { @service_catalog.get_endpoint(:cloudServersOpenStack, :sat) }
      raises(RuntimeError) { @service_catalog.get_endpoint(:cloudServersOpenStack, :sat, true) }
      raises(RuntimeError) { @service_catalog.get_endpoint(:not_here, :dfw) }
      raises(RuntimeError) { @service_catalog.get_endpoint('non-existent') }
      raises(RuntimeError)  { @service_catalog.get_endpoint(:cloudServersOpenStack, :ord, true) }
    end
  end

  tests('reload').succeeds do
    pending if Fog.mocking?

    service = Fog::Identity[:rackspace]
    service_catalog = service.service_catalog
    service_catalog.catalog << {"name"=>"fakeService", "endpoints"=>[{ "publicURL"=>"http:///fake-endpoint.com"}]}
    returns("http:///fake-endpoint.com") { service_catalog.get_endpoint :fakeService }
    returns("http:///fake-endpoint.com") { service.service_catalog.get_endpoint :fakeService }
    service_catalog.reload
    raises(RuntimeError) { service_catalog.get_endpoint :fakeService }
    raises(RuntimeError) { service.service_catalog.get_endpoint :fakeService }
  end

  tests('display_service_regions') do

    tests('with global endpoint').returns(":dfw, :ord, :global") do
      catalog_hash =  [{"type"=>"compute", "endpoints"=>[{"region"=>"DFW", "versionId"=>"2",
      "tenantId"=>"777", "versionList"=>"https://dfw.servers.api.rackspacecloud.com/", "versionInfo"=>"https://dfw.servers.api.rackspacecloud.com/v2",
      "publicURL"=>"https://dfw.servers.api.rackspacecloud.com/v2/777"}, {"region"=>"ORD", "versionId"=>"2", "tenantId"=>"777",
      "versionList"=>"https://ord.servers.api.rackspacecloud.com/", "versionInfo"=>"https://ord.servers.api.rackspacecloud.com/v2",
      "publicURL"=>"https://ord.servers.api.rackspacecloud.com/v2/777"}, {"versionId"=>"2", "tenantId"=>"777", "versionList"=>"https://servers.api.rackspacecloud.com/", "versionInfo"=>"https://servers.api.rackspacecloud.com/v2", "publicURL"=>"https://servers.api.rackspacecloud.com/v2/777"}], "name"=>"cloudServersOpenStack"}]
      @service_catalog = Fog::Rackspace::Identity::ServiceCatalog.new(:service => nil, :catalog => catalog_hash)

     @service_catalog.display_service_regions(:cloudServersOpenStack)
    end

    tests('endpoint types') do
      catalog_hash =  [{"type"=>"object-store", "endpoints"=>[{"internalURL"=>"https://snet-storage101.dfw1.clouddrive.com/v1/Mosso777", "region"=>"DFW",
      "tenantId"=>"Mosso777",
      "publicURL"=>"https://storage101.dfw1.clouddrive.com/v1/Mosso777"},
      { "region"=>"ORD",
      "tenantId"=>"Mosso777",
      "publicURL"=>"https://storage101.ord1.clouddrive.com/v1/Mosso777"}], "name"=>"cloudFiles"},]
      @service_catalog = Fog::Rackspace::Identity::ServiceCatalog.new(:service => nil, :catalog => catalog_hash)
      tests('public').returns(":dfw, :ord") do
        @service_catalog.display_service_regions(:cloudFiles)
      end
      tests('private').returns(":dfw") do
        @service_catalog.display_service_regions(:cloudFiles, true)
      end
    end
  end
end
