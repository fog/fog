module Fog
  module TerremarkEcloud
    class Compute

      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_vm'

        def get_vm(uri)
          request({
                    :uri        => uri,
                    :idempotent => true,
                    :parser     => Fog::Parsers::TerremarkEcloud::Compute::GetVm.new
                  })
        end

      end
    end
  end
end
