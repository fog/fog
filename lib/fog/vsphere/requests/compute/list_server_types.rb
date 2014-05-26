module Fog
  module Compute
    class Vsphere
      class Real
        def list_server_types(filters={})
          datacenter_name = filters[:datacenter]
          servertypes=raw_server_types(datacenter_name)
          if servertypes
            servertypes.map do | servertype |
               server_type_attributes(servertype, datacenter_name)
            end.compact
          else
            nil
          end
          #select{ | guestdesc | guestdesc.select{ | k, v | filter.has_key?(k) and filter[k] == v }==filter }
        end

        def raw_server_types(datacenter_name, filter={})
          datacenter=find_raw_datacenter(datacenter_name)
          environmentBrowser=datacenter.hostFolder.childEntity.grep(RbVmomi::VIM::ComputeResource).first.environmentBrowser
          if environmentBrowser
            environmentBrowser.QueryConfigOption[:guestOSDescriptor]
          end
        end

        protected

        def server_type_attributes(servertype, datacenter)
          {
            :id         => servertype.id,
            :name       => servertype.id,
            :family     => servertype.family,
            :fullname   => servertype.fullName,
            :datacenter => datacenter,
          }
        end
      end
      class Mock
        def list_server_types(datacenter_name)
          [{:id=>"rhel6Guest",
            :name=>"rhel6Guest",
            :family=>"linuxGuest",
            :fullname=>"Red Hat Enterprise Linux 6 (32-Bit)",
            :datacenter=>"Solutions"},
           {:id=>"rhel5_64Guest",
            :name=>"rhel5_64Guest",
            :family=>"linuxGuest",
            :fullname=>"Red Hat Enterprise Linux 5 (64-Bit)",
            :datacenter=>"Solutions"}]
        end
      end
    end
  end
end
