require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Vcloud

    extend Fog::Provider

    service(:compute, 'vcloud/compute')

  end
end
