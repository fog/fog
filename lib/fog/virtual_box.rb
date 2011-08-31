require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module VirtualBox

    extend Fog::Provider

    service(:compute, 'virtual_box/compute')

  end
end
