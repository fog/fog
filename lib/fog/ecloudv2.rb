require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Ecloudv2

    extend Fog::Provider

    service(:compute, 'ecloudv2/compute', 'Compute')

  end
end
