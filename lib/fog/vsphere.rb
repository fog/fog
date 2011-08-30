require 'fog/core'

module Fog
  module Vsphere

    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error; end
    end

    service(:compute, 'vsphere/compute')

  end
end
