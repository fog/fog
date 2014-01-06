require 'fog/core/collection'
require 'fog/xenserver/models/compute/host_crash_dump'

module Fog
  module Compute
    class XenServer
      class HostCrashDumps < Fog::Collection
        model Fog::Compute::XenServer::HostCrashDump

        def all(options={})
          data = service.get_records 'host_crashdump'
          load(data)
        end

        def get( host_crashdump_ref )
          if host_crashdump_ref && host_crashdump = service.get_record( host_crashdump_ref, 'host_crashdump' )
            new(host_crashdump)
          else
            nil
          end
        end
      end
    end
  end
end
