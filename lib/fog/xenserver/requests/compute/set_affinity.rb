module Fog
  module Compute
    class XenServer
      class Real
        require 'fog/xenserver/parser'

        def set_affinity( host_ref )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.set_affinity'}, host_ref)
        end
      end

      class Mock
        def set_affinity( uuid )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
