module Fog
  module Compute
    class XenServer
      class Real
        def create_vdi( config )
          raise ArgumentError.new('Invalid #config') if config.nil?
          raise ArgumentError.new('Missing #virtual_size attribute') if config[:virtual_size].nil?
          raise ArgumentError.new('Missing #read_only attribute') if config[:read_only].nil?
          raise ArgumentError.new('Missing #type attribute') if config[:type].nil?
          raise ArgumentError.new('Missing #sharable attribute') if config[:sharable].nil?
          raise ArgumentError.new('Missing #other_config attribute') if config[:other_config].nil?

          if config[:storage_repository].nil? && config[:SR].nil? && config[:__sr].nil?
            raise ArgumentError.new('Missing StorageRepository reference.')
          end

          unless config[:storage_repository].nil?
            Fog::Logger.deprecation(
                'The attribute #storage_repository is deprecated. Use #SR instead.'
            )
            config[:SR] = config[:storage_repository].reference
          end

          unless config[:__sr].nil?
            Fog::Logger.deprecation(
                'The attribute #__sr is deprecated. Use #SR instead.'
            )
            config[:SR] = config[:__sr]
          end

          unless config[:name].nil?
            Fog::Logger.deprecation(
                'The attribute #name is deprecated. Use #name_label instead.'
            )
            config[:name_label] = config[:name]
          end

          unless config[:description].nil?
            Fog::Logger.deprecation(
                'The attribute #description is deprecated. Use #name_description instead.'
            )
            config[:name_description] = config[:description]
          end

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
