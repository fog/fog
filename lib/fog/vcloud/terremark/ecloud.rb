module Fog
  module Vcloud
    module Terremark
      module Ecloud
        extend Fog::Vcloud::Extension

        model_path 'fog/vcloud/terremark/ecloud/models'
        model :catalog_item
        model :catalog
        model :internet_service
        model :internet_services
        model :ip
        model :ips
        model :network
        model :networks
        model :node
        model :nodes
        model :public_ip
        model :public_ips
        model :server
        model :servers
        model :task
        model :tasks
        model :vdc
        model :vdcs

        request_path 'fog/vcloud/terremark/ecloud/requests'
        request :add_internet_service
        request :add_node
        request :configure_internet_service
        request :configure_network
        request :configure_network_ip
        request :configure_node
        request :configure_vapp
        request :delete_internet_service
        request :delete_node
        request :delete_vapp
        request :get_catalog
        request :get_catalog_item
        request :get_customization_options
        request :get_internet_services
        request :get_network
        request :get_network_ip
        request :get_network_ips
        request :get_network_extensions
        request :get_node
        request :get_nodes
        request :get_public_ip
        request :get_public_ips
        request :get_task
        request :get_task_list
        request :get_vapp
        request :get_vdc
        request :power_off
        request :power_on
        request :power_reset
        request :power_shutdown

        versions "v0.8b-ext2.3"

        module Mock
          def self.base_url
            "https://fakey.com/api/v0.8b-ext2.3"
          end

          def self.data_reset
            @mock_data = nil
            Fog::Vcloud::Mock.data_reset
          end

          def self.extension_url
            self.base_url + "/extensions"
          end

          def self.data( base_url = self.base_url )
            @mock_data ||= begin
              extension_href = 
              vcloud_data = Fog::Vcloud::Mock.data(base_url)
              vcloud_data.delete( :versions )
              vcloud_data.merge!( :versions => [ { :version => "v0.8b-ext2.3", :login_url => "#{base_url}/login", :supported => true } ] )

              vcloud_data[:organizations][0][:vdcs][0][:public_ips] =
                  [
                    { :id => "51",
                      :href => extension_url + "/publicIp/51",
                      :name => "99.1.2.3",
                      :services => [
                        { :id => "71", :port => "80", :protocol => 'HTTP', :enabled => "true", :timeout => "2", :name => 'Web Site', :description => 'Web Servers' },
                        { :id => "72", :port => "7000", :protocol => 'HTTP', :enabled => "true", :timeout => "2", :name => 'An SSH Map', :description => 'SSH 1' }
                      ]
                    },
                    { :id => "52",
                      :href => extension_url + "/publicIp/52",
                      :name => "99.1.2.4",
                      :services => [
                        { :id => "73", :port => "80", :protocol => 'HTTP', :enabled => "true", :timeout => "2", :name => 'Web Site', :description => 'Web Servers' },
                        { :id => "74", :port => "7000", :protocol => 'HTTP', :enabled => "true", :timeout => "2", :name => 'An SSH Map', :description => 'SSH 2' }
                      ]
                    },
                    { :id => "53",
                      :href => extension_url + "/publicIp/53",
                      :name => "99.1.9.7",
                      :services => []
                    }
                  ]

              vcloud_data[:organizations][0][:vdcs][1][:public_ips] =
                  [
                    { :id => "54",
                      :href => extension_url + "/publicIp/54",
                      :name => "99.99.99.99",
                      :services => []
                    }
                  ]

              vcloud_data[:organizations].each do |organization|
                organization[:info][:extension_href] = extension_url
                organization[:vdcs].each do | vdc|
                  vdc[:extension_href] = "#{base_url}/extensions/vdc/#{vdc[:id]}"
                  vdc[:networks].each do |network|
                    network[:extension_href] = "#{extension_url}/network/#{network[:id]}"
                    network[:rnat] = vdc[:public_ips].first[:name]
                  end
                end
              end

              vcloud_data
            end
          end

          def self.public_ip_href(ip)
            "#{base_url}/extensions/publicIp/#{ip[:id]}"
          end

          def self.internet_service_href(internet_service)
            "#{base_url}/extensions/internetService/#{internet_service[:id]}"
          end

          def ecloud_xmlns
            { :xmlns => "urn:tmrk:eCloudExtensions-2.3", :"xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance" }
          end

          def mock_data
            Fog::Vcloud::Terremark::Ecloud::Mock.data
          end
        end


        private

        # If we don't support any versions the service does, then raise an error.
        # If the @version that super selected isn't in our supported list, then select one that is.
        def check_versions
          super
          unless (supported_version_ids & Versions::SUPPORTED).length > 0
            raise UnsupportedVersion.new("\nService @ #{@versions_uri} supports: #{supported_version_ids.join(', ')}\n" +
                                         "Fog::Vcloud::Terremark::Ecloud supports: #{Versions::SUPPORTED.join(', ')}")
          end
          unless supported_version_ids.include?(@version)
            @version = (supported_version_ids & Versions::SUPPORTED).sort.first
          end
        end
      end
    end
  end
end
