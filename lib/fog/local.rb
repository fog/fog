require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Local

    extend Fog::Provider

    service(:storage, 'local/storage')

  end
end
