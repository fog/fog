require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Ecloud

    extend Fog::Provider

    service(:compute, 'ecloud/compute')

  end
end
