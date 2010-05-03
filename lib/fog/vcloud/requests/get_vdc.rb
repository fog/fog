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
        if vdc = DATA[:organizations].map { |org| org[:vdcs] }.flatten.detect { |vdc| vdc[:href] == vdc_uri }
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
              #FIXME: Incomplete
            }, { 'Content-Type' => 'application/vnd.vmware.vcloud.vdc+xml' }
        else
          mock_error 200, "401 Unauthorized"
        end
      end

    end
  end
end
