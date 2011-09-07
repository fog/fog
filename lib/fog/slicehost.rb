require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Slicehost

    extend Fog::Provider

    service(:compute, 'slicehost/compute')
    service(:dns,     'slicehost/dns')

  end
end
