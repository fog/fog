require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Brightbox
    extend Fog::Provider

    service(:compute, 'brightbox/compute')

  end
end
