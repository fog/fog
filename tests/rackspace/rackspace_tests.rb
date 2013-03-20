Shindo.tests('Fog::Rackspace', ['rackspace']) do

  tests('normalize_url') do
    tests('should return nil if endpoint is nil').returns(nil) do
      Fog::Rackspace.normalize_url nil
    end
    tests('should remove trailing spaces').returns("https://dfw.blockstorage.api.rackspacecloud.com/v1") do
      Fog::Rackspace.normalize_url "https://dfw.blockstorage.api.rackspacecloud.com/v1 "
    end
    tests('should remove trailing /').returns("https://dfw.blockstorage.api.rackspacecloud.com/v1") do
      Fog::Rackspace.normalize_url "https://dfw.blockstorage.api.rackspacecloud.com/v1/"
    end
    tests('should downcase url').returns("https://dfw.blockstorage.api.rackspacecloud.com/v1") do
      Fog::Rackspace.normalize_url "HTTPS://DFW.BLOCKSTORAGE.API.RACKSPACECLOUD.COM/V1"
    end
    tests('show do all three').returns("https://dfw.blockstorage.api.rackspacecloud.com/v1") do
      Fog::Rackspace.normalize_url "HTTPS://DFW.BLOCKSTORAGE.API.RACKSPACECLOUD.COM/V1/ "
    end
  end

end