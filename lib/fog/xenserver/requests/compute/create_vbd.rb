module Fog
  module Compute
    class XenServer
      class Real
        def create_vbd( vm_ref, vdi_ref = '', config = {} )
          if vm_ref.is_a?(Hash)
            default_config = vm_ref.reject! { |_k,v| v.nil? }
          else
            Fog::Logger.deprecation(
                'This api is deprecated. The only expected param is a hash of attributes.'
            )

            raise ArgumentError.new('Invalid config') if config.nil?
            vm_ref = vm_ref.reference if vm_ref.kind_of? Fog::Compute::XenServer::Server
            vdi_ref = vdi_ref.reference if vdi_ref.kind_of? Fog::Compute::XenServer::VDI
            config.reject! { |k,v| (k == :server) or (k == :vdi) }
            default_config = {
                :VM => vm_ref,
                :VDI => vdi_ref,
                :empty => false,
                :other_config => {'owner' => ''},
                :userdevice => "0",
                :bootable => true,
                :mode => 'RW',
                :qos_algorithm_type=> '',
                :qos_algorithm_params=> {},
                :qos_supported_algorithms=> [],
                :type => 'Disk'
            }.merge config
          end

          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VBD.create'}, default_config )
        end
      end

      class Mock
        def create_vbd( config )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
