module Fog
  module TerremarkEcloud
    class Compute

      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_task'

        def get_task(uri)
          request({
              :uri        => uri,
              :idempotent => true,
              :parser     => Fog::Parsers::TerremarkEcloud::Compute::GetTask.new
            })
        end

      end
    end
  end
end
