module Fog
  module Compute
    class XenServer
      class Real
        #
        # Create a storage repository (SR)
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=SR
        #
        # @param [String] host_ref host reference
        # @param [String] name_label repository label
        # @param [String] type storage repository type
        # @param [String] name_description storage repository description
        # @param [Hash]   device_config used to specify block device path, like
        # { :device => /dev/sdb } for example
        # @param [String] physical_size '0' will use the whole device (FIXME
        # needs confirmation)
        # @param [String] content_type the type of the SR's content.
        # According to Citrix documentation, used only to distinguish ISO
        # libraries from other SRs. Set it to 'iso' for storage repositories
        # that store a library of ISOs, 'user' or '' (empty) otherwise.
        # @see http://docs.vmd.citrix.com/XenServer/6.1.0/1.0/en_gb/reference.html#cli-xe-commands_sr
        # @param [String] shared
        #
        # @return [String] an OpaqueRef to the storage repository
        def create_sr( host_ref,
            name_label,
            type = '',
            name_description = '',
            device_config    = {},
            physical_size    = '0',
            content_type     = 'user',
            shared           = false,
            sm_config        = {} )

          if host_ref.is_a?(Hash)
            config = host_ref
            extra_params = name_label

            [:physical_size, :name, :description, :type, :content_type, :shared, :sm_config].each do |attribute|
              raise "Missing Argument in first param: #{attribute}" if config[attribute].nil?
            end

            [:host_ref, :device_config].each do |attribute|
              raise "Missing Argument in second param: #{attribute}" if extra_params[attribute].nil?
            end

            @connection.request({ :parser => Fog::Parsers::XenServer::Base.new, :method => 'SR.create' },
                extra_params[:host_ref], extra_params[:device_config], config[:physical_size],
                config[:name], config[:description], config[:type], config[:content_type],
                config[:shared], config[:sm_config])
          else
            Fog::Logger.deprecation(
                'This api is deprecated. The expected params are two hashes of attributes.'
            )

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
