require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module GoGrid

    extend Fog::Provider

    service(:compute, 'go_grid/compute')

  end
end
