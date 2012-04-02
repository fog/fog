module Fog
  module Compute
    class XenServer

      class Real

        def create_server( name_label, template = nil, network = nil, extra_args = {})
          create_vm( name_label, template, network, extra_args)
        end

      end

      class Mock

        def create_server()
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
