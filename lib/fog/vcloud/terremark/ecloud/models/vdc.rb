module Fog
  module Vcloud
    module Terremark
      module Ecloud
        class Vdc < Fog::Vcloud::Vdc

          delete_attribute :enabled
          delete_attribute :vm_quota
          delete_attribute :nic_quota
          delete_attribute :network_quota
          delete_attribute :allocation_model

          attribute :deployed_vm_quota
          attribute :instantiated_vm_quota

          def public_ips
            @public_ips ||= Fog::Vcloud::Terremark::Ecloud::PublicIps.new( :connection => connection,
                                                                           :href => other_links.detect { |link| link.type == "application/vnd.tmrk.ecloud.publicIpsList+xml" }.href )
          end

          def internet_services
            @internet_services ||= Fog::Vcloud::Terremark::Ecloud::InternetServices.
              new( :connection => connection,
                   :href => href.to_s.gsub('vdc','extensions/vdc') + "/internetServices" )
          end

        end
      end
    end
  end
end
