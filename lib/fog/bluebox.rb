module Fog
  module Bluebox

    extend Fog::Provider

    service_path 'fog/bluebox'
    service :blocks

  end
end
