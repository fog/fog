module Fog
  module Compute
    class XenServer

      class Real
        
        def create_vdi( config )
          raise ArgumentError.new('Invalid config') if config.nil?
          config[:SR] = config[:storage_repository].reference
          config[:name_label] = config[:name]
          config[:name_description] = config[:description] if config[:description]
          config.reject! { |k,v| (k == :__sr) or (k == :storage_repository) }
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VDI.create'}, config )
        end
      end

      class Mock
        
        def create_vdi( ref )
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
