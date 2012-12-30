module Fog
  module Compute
    class XenServer

      class Real
        
        #
        # Create a storage repository (SR)
        #
        # http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=SR
        #
        def create_sr( host_ref,
                       name_label, 
                       type,
                       name_description = nil,
                       device_config    = {}, 
                       physical_size    = '0',
                       content_type     = nil, 
                       shared           = false, 
                       sm_config        = {} )

          @connection.request(
            {:parser => Fog::Parsers::XenServer::Base.new, :method => 'SR.create'}, 
            host_ref, 
            device_config || {}, 
            physical_size || '0', 
            name_label, 
            name_description || '',
            type,
            content_type, 
            shared || false,
            sm_config || {}
          )
        end

      end

      class Mock
        
        def create_sr( host_ref,
                       name_label, 
                       type,
                       name_description = nil,
                       device_config    = {}, 
                       physical_size    = '0',
                       content_type     = nil, 
                       shared           = false, 
                       sm_config        = {} )
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
