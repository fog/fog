require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Linode
    extend Fog::Provider
    service(:compute, 'linode/compute')
    service(:dns,     'linode/dns')
  end
end

