require 'fog/core'

module Fog
  module Ovirt

    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error; end
      class SecurityError < ServiceError; end
      class NotFound < ServiceError; end
    end

    service(:compute, 'ovirt/compute', 'Compute')

  end
end
