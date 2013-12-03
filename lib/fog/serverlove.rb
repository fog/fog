require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Serverlove
    extend Fog::Provider

    service(:compute, 'serverlove/compute', 'Compute')

  end
end
