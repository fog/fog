require "fog/core"

module Fog
  module Azure
    extend Fog::Provider
    service(:compute, "Compute")
  end
end
