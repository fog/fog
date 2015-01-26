module Fog
  module Compute
    class XenServer
      class Real
        def unplug_pbd( ref )
          @connection.request(
            {:parser => Fog::Parsers::XenServer::Base.new, :method => 'PBD.unplug'},
            ref
          )
        end
      end

      class Mock
        def unplug_pbd( ref )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
