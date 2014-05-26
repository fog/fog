require 'set'

module Fog
  module Compute
    class CloudSigma
      class Real
        def update_server(server_id, data)
          update_request("servers/#{server_id}/", data)
        end
      end

      class Mock
        def update_server(server_id, data)
          mock_update(data, :servers, 200, server_id) do |old_data, new_data|
            old_nics = old_data['nics']
            new_nics = new_data['nics']

            old_nics_macs = old_nics.map { |nic| nic['mac'] }.compact
            new_nics_macs = new_nics.map { |nic| nic['mac'] }.compact

            newly_created_macs = Set.new(new_nics_macs) - old_nics_macs
            unless newly_created_macs.empty?
              mac_err = <<-EOS
              MAC(s) #{newly_created_macs.to_a} not specified on guest #{server_id}. Nic MACs are automatically assigned at
              creation time and cannot be changed. Do not specify MAC to create a new NIC or specify existing MAC to
              update existing NIC.
              EOS
              raise Fog::CloudSigma::Errors::RequestError.new(mac_err, 'permission')
            end

            new_nics.each { |nic| nic['mac'] ||= Fog::Compute::CloudSigma::Mock.random_mac }

            old_data.merge(new_data)
          end
        end
      end
    end
  end
end
