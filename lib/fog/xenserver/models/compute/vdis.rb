require 'fog/core/collection'
require 'fog/xenserver/models/compute/vdi'

module Fog
  module Compute
    class XenServer

      class Vdis < Fog::Collection

        model Fog::Compute::XenServer::VDI
        
        def initialize(attributes)
          super
        end

        def all(options = {})
          data = connection.get_records 'VDI'
          #data.delete_if { |vm| vm[:is_a_template] and !options[:include_templates] }
          load(data)
        end

        def get( vdi_ref )
          if vdi_ref && vdi = connection.get_record( vdi_ref, 'VDI' )
            new(vdi)
          end
        rescue Fog::XenServer::NotFound
          nil
        end

      end

    end
  end
end
