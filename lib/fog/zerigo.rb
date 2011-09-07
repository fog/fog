require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Zerigo

    extend Fog::Provider

    service(:dns, 'zerigo/dns')

  end
end
