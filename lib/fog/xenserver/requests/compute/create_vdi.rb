module Fog
  module Compute
    class XenServer
      class Real
        def create_vdi( config )
          raise ArgumentError.new('Invalid config') if config.nil?
          raise ArgumentError.new('Missing virtual_size attribute') if config[:virtual_size].nil?
          raise ArgumentError.new('Missing read_only attribute') if config[:read_only].nil?
          raise ArgumentError.new('Missing type attribute') if config[:type].nil?
          raise ArgumentError.new('Missing sharable attribute') if config[:sharable].nil?
          raise ArgumentError.new('Missing other_config attribute') if config[:other_config].nil?
          raise ArgumentError.new('Missing storage_repository attribute') if config[:storage_repository].nil?
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
