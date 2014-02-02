require 'fog/core'

module Fog
  module Vsphere

    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error; end
      class SecurityError < ServiceError; end
      class NotFound < ServiceError; end
    end

    service(:compute, 'vsphere/compute', 'Compute')

  end
end
