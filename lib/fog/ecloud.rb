require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Ecloud

    extend Fog::Provider

    service(:compute, 'ecloud/compute', 'Compute')

  end
end

module Fog
  module Ecloud
    ECLOUD_OPTIONS = [:ecloud_authentication_method]
  end
end
