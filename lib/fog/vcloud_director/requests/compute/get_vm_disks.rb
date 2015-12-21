module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/disks'

        # Retrieve all RASD items that specify hard disk and hard disk
        # controller properties of a VM.
        #
        # @deprecated Use {#get_disks_rasd_items_list} instead.
        # @todo Log deprecation warning.
        #
        # @param [String] id
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-DisksRasdItemsList.html
        # @since vCloud API version 0.9
        def get_vm_disks(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Compute::VcloudDirector::Disks.new,
            :path       => "vApp/#{id}/virtualHardwareSection/disks"
          )
        end
      end
      class Mock
        def get_vm_disks(id)
          disks = data[:disks].values.select {|d| d[:parent_vm] == id}.each_with_index.map do |disk, i|
            {
              :address => i,
              :description => disk[:description],
              :name => disk[:name],
              :id => (i+1)*1000,
              :resource_type => 17,
              :capacity => disk[:capacity],
            }
          end
          body = {:type => 'application/vnd.vmware.vcloud.rasditemslist+xml', :disks => disks}
          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
