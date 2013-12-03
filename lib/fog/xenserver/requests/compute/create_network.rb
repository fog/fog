module Fog
  module Compute
    class XenServer

      class Real

        # Create a Network
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=network
        #
        def create_network( name, config = {} )
          config.reject! { |k,v| v.nil? }

          default_config = { 
            :name_label => name, 
            # Description is mandatory in XenAPI but we default to empty
            :name_description => config[:description] || '',
            # Mandatory, but can be empty
            :other_config => {}
          }.merge config

          @connection.request(
            {
              :parser => Fog::Parsers::XenServer::Base.new, 
              :method => 'network.create'
            }, 
            default_config 
          )
        end
      end

      class Mock
        
        def create_network( name, description = '', config = {} )
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
