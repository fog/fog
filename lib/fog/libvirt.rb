begin
  require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))
rescue LoadError => e
  retry if require('rubygems')
  raise e.message
end

module Fog
  module Libvirt

    extend Fog::Provider

    service(:compute, 'libvirt/compute', 'Compute')

  end
end
