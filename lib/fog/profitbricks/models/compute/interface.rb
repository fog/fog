module Fog
    module Compute
        class ProfitBricks
            class Interface < Fog::Model
                identity  :id,                  :aliases => 'nicId'
                attribute :name,                :aliases => 'nicName'
                attribute :mac_address,         :aliases => 'macAddress'
                attribute :lan_id,              :aliases => 'lanId'
                attribute :dhcp_active,         :aliases => 'dhcpActive'
                attribute :ips,                 :aliases => 'ips'
                attribute :server_id,           :aliases => 'serverId'
                attribute :internet_access,     :aliases => 'internetAccess'
                attribute :state,               :aliases => 'provisioningState'
                attribute :firewall
                attribute :data_center_id,      :aliases => 'dataCenterId'
                attribute :data_center_version, :aliases => 'dataCenterVersion'
                attribute :request_id,          :aliases => 'requestId'

                attr_accessor :options

                def initialize(attributes={})
                    super
                end

                def save
                    requires :server_id, :lan_id

                    data = service.create_nic(server_id, lan_id, options={})
                    merge_attributes(data.body['createNicResponse'])
                    true
                end

                def update
                    requires :id

                    data = service.update_nic(id, options)
                    merge_attributes(data.body['updateNicResponse'])
                    true
                end

                def destroy
                    requires :id
                    service.delete_nic(id)
                    true
                end

                def set_internet_access(options={})
                    service.set_internet_access(
                        options[:data_center_id], options[:lan_id], options[:internet_access]
                    )
                    true
                end

                def ready?
                    self.state == 'AVAILABLE'
                end

                def failed?
                    self.state == 'ERROR'
                end
            end
        end
    end
end