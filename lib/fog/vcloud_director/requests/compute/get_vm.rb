module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/vm'

        # Retrieve a vApp or VM.
        #
        # @note This should probably be deprecated.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see #get_vapp
        def get_vm(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Compute::VcloudDirector::Vm.new,
            :path       => "vApp/#{id}"
          )
        end
      end
      class Mock
        def get_vm(id)
          vapp = get_vapp(id).body
          vm = parse_vapp_to_vm(vapp)
          body = {:type => vapp[:type], :vm => vm}
          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
        
        # Mock equivalent of Fog::Parsers::Compute::VcloudDirector::Vm
        def parse_vapp_to_vm(vapp)
          parser = Fog::Parsers::Compute::VcloudDirector::Vm.new
          vm = vapp.select {|k| [:href, :name, :status, :type].include? k}
          network = vapp[:NetworkConnectionSection]
          vm.merge({
            :id => vapp[:href].split('/').last,
            :status => parser.human_status(vapp[:status]),
            :ip_address => network[:NetworkConnection][:IpAddress],
            :description => vapp[:Description],
            :cpu => get_hardware(vapp, 3),
            :memory => get_hardware(vapp, 4),
            :disks => get_disks(vapp),
            :links => [vapp[:GuestCustomizationSection][:Link]],
          })
        end
        
        def get_hardware(vapp, resource_type)
          hardware = vapp[:"ovf:VirtualHardwareSection"][:"ovf:Item"]
          item = hardware.find {|h| h[:"rasd:ResourceType"].to_i == resource_type}
          if item and item.key? :"rasd:VirtualQuantity"
            item[:"rasd:VirtualQuantity"].to_i
          else
            nil
          end
        end
        
        def get_disks(vapp)
          hardware = vapp[:"ovf:VirtualHardwareSection"][:"ovf:Item"]
          disks = hardware.select {|h| h[:"rasd:ResourceType"].to_i == 17}
          disks.map {|d| {d[:"rasd:ElementName"] => d[:"rasd:HostResource"][:ns12_capacity].to_i}}
        end
        
      end
    end
  end
end
