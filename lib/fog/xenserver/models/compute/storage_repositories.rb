require 'fog/core/collection'
require 'fog/xenserver/models/compute/storage_repository'

module Fog
  module Compute
    class XenServer

      class StorageRepositories < Fog::Collection

        model Fog::Compute::XenServer::StorageRepository

        def all
          data = connection.get_records 'SR'
          #data.delete_if {|sr| sr[:shared].eql?(false)}
          #data.delete_if {|sr| sr[:content_type].eql?('iso')}
          load(data)
        end

        def get( sr_ref )
          if sr_ref && sr = connection.get_record( sr_ref, 'SR' )
            new(sr)
          else
            nil
          end
        end

      end

    end
  end
end
