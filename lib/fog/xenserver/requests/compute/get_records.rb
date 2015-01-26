module Fog
  module Compute
   class XenServer
      class Real
        require 'fog/xenserver/parsers/get_records'

        def get_records( klass, options = {} )
          begin
            res = @connection.request(:parser => Fog::Parsers::XenServer::GetRecords.new, :method => "#{klass}.get_all_records")
            res
          rescue Fog::XenServer::RequestFailed => e
            []
          end
        end
      end

      class Mock
        def get_vms
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
