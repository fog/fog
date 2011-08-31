require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Libvirt

    extend Fog::Provider

    service(:compute, 'libvirt/compute')

  end
end
