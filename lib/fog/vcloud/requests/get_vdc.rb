module Fog
  module Vcloud

    class Real
      # Get details of a vdc
      def get_vdc(vdc_uri)
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Vcloud::GetVdc.new,
          :uri      => vdc_uri
        )
      end

    end

    class Mock
      # WARNING: Incomplete
      #Based off of:
      #vCloud API Guide v0.9 - Page 27

      def get_vdc(vdc_uri)
        if vdc = DATA[:organizations].map { |org| org[:vdcs] }.flatten.detect { |vdc| URI.parse(vdc[:href]) == vdc_uri }
          xml = Builder::XmlMarkup.new
          mock_it Fog::Parsers::Vcloud::GetVdc.new, 200,
            xml.Vdc(xmlns.merge(:href => vdc[:href], :name => vdc[:name])) {
              xml.Link(:rel => "up",
                       :href => DATA[:organizations].detect { |org| org[:vdcs].detect { |_vdc| vdc[:href] == _vdc[:href] }[:href] == vdc[:href] }[:info][:href],
                       :type => "application/vnd.vmware.vcloud.org+xml")
              xml.Link(:rel => "add",
                       :href => vdc[:href] + "/action/uploadVAppTemplate",
                       :type => "application/vnd.vmware.vcloud.uploadVAppTemplateParams+xml")
              xml.Link(:rel => "add",
                       :href => vdc[:href] + "/media",
                       :type => "application/vnd.vmware.vcloud.media+xml")
              xml.Link(:rel => "add",
                       :href => vdc[:href] + "/action/instantiateVAppTemplate",
                       :type => "application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml")
              xml.Link(:rel => "add",
                       :type => "application/vnd.vmware.vcloud.cloneVAppParams+xml",
                       :href => vdc[:href] + "/action/cloneVApp")
              xml.Link(:rel => "add",
                       :type => "application/vnd.vmware.vcloud.captureVAppParams+xml",
                       :href => vdc[:href] + "/action/captureVApp")
              xml.Link(:rel => "add",
                       :type => "application/vnd.vmware.vcloud.composeVAppParams+xml",
                       :href => vdc[:href] + "/action/composeVApp")
              xml.AllocationModel("AllocationPool")
              xml.Description(vdc[:name] + " VDC")
              xml.ResourceEntities {
                DATA[:vdc_resources].each do |resource|
                  xml.ResourceEntity(resource)
                end
              }
              xml.AvailableNetworks {
                vdc[:networks].each do |network|
                  xml.Network( :name => network[:name], :href => network[:href], :type => "application/vnd.vmware.vcloud.network+xml" )
                end
              }
              xml.ComputeCapacity{
                xml.Cpu {
                  xml.Units("Mhz")
                  xml.Allocated(vdc[:cpu][:allocated])
                  xml.Limit(vdc[:cpu][:allocated])
                }
                xml.Memory {
                  xml.Units("MB")
                  xml.Allocated(vdc[:memory][:allocated])
                  xml.Limit(vdc[:memory][:allocated])
                }
              }
              xml.StorageCapacity{
                xml.Units("MB")
                xml.Allocated(vdc[:storage][:allocated])
                xml.Limit(vdc[:storage][:allocated])
              }
              xml.VmQuota(0)
              xml.NicQuota(0)
              xml.IsEnabled('true')
              xml.NetworkQuota(0)
              #FIXME: Incomplete
            }, { 'Content-Type' => 'application/vnd.vmware.vcloud.vdc+xml' }
        else
          mock_error 200, "401 Unauthorized"
        end
      end

    end
  end
end
