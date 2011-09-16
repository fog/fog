require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Vmfusion

    extend Fog::Provider

    service(:compute, 'vmfusion/compute')

  end
end
