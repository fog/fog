module Fog
  module Compute
    class XenServer

      class Real

        def scan_sr( ref, extra_args = {})
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'SR.scan'}, ref)
        end

      end

      class Mock

        def scan_sr(ref, extra_args = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
