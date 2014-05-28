module Fog
  module Compute
    class VcloudDirector
      class Real
        # Compose a vApp from existing virtual machines.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vdc.
        # @param [Hash] options
        # @option options [Boolean] :powerOn Used to specify whether to power
        #   on vApp on deployment, if not set default value is true.
        # @option options [Boolean] :deploy Used to specify whether to deploy
        #   the vApp, if not set default value is true.
        # @option options [String] :name Used to identify the vApp.
        # @option options [String] :networkName Used to conect the vApp and VMs to a VDC network, which has
        # to exist beforehand.
        # @option options [String] :networkHref Used to conect the vApp and VMs to a VDC network, which has
        # to exist beforehand.
        # @option options [String] :fenceMode Used to configure the network Mode (briged, isolated).
        # @option options [String] :source_vms Array with VMs to be used to compose the vApp, each containing -
        # :name, :href, :isGuestCustomizationEnabled, :computer_name and :ipAllocationMode (e.g. 'DHCP').
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-ComposeVApp.html
        # @since vCloud API version 0.9
        def post_compose_vapp(id, options={})
          body = Nokogiri::XML::Builder.new do |xml|
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:ovf' => "http://schemas.dmtf.org/ovf/envelope/1"
            }
            [:deploy, :powerOn, :name].each { |a| attrs[a] = options[a] if options.key?(a) }

            xml.ComposeVAppParams(attrs) {
              xml.Description options[:Description] if options.key?(:Description)
              xml.InstantiationParams {
                xml.NetworkConfigSection {
                  xml['ovf'].Info
                  xml.NetworkConfig(:networkName => options[:networkName]) {
                    xml.Configuration {
                      xml.ParentNetwork(:href => options[:networkHref])
                      xml.FenceMode options[:fenceMode]
                    }
                  }
                }
              }
              options[:source_vms].each do |vm|
                xml.SourcedItem {
                  xml.Source(:name => vm[:name], :href => vm[:href])
                  xml.InstantiationParams {
                    xml.NetworkConnectionSection(:href => "#{vm[:href]}/networkConnectionSection/", :type => "application/vnd.vmware.vcloud.networkConnectionSection+xml") {
                      xml['ovf'].Info
                      xml.PrimaryNetworkConnectionIndex 0
                      xml.NetworkConnection(:network => options[:networkName]) {
                        xml.NetworkConnectionIndex 0
                        xml.IsConnected true
                        xml.IpAddressAllocationMode vm[:ipAllocationMode]
                      }
                    }
                    xml.GuestCustomizationSection(:xmlns => "http://www.vmware.com/vcloud/v1.5", 'xmlns:ovf' => "http://schemas.dmtf.org/ovf/envelope/1") {
                      xml['ovf'].Info
                      xml.Enabled vm[:isGuestCustomizationEnabled]
                      xml.ComputerName vm[:computerName]
                    }
                  }
                }
              end
            }
          end.to_xml

          request(
            :body => body,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.composeVAppParams+xml'},
            :method => 'POST',
            :parser => Fog::ToHashDocument.new,
            :path => "vdc/#{id}/action/composeVApp"
          )
        end
      end
    end
  end
end
