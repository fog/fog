# -*- encoding: utf-8 -*-
module Fog
  module Vcloud
    class Compute
      class Real
        def configure_vm_customization_script(vmdata)
          edit_uri = vmdata[:href]
          body = <<EOF
          <GuestCustomizationSection xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1" type="application/vnd.vmware.vcloud.guestCustomizationSection+xml" href="https://zone01.bluelock.com/api/vApp/vm-cc8e27be-f18c-4263-87c5-58a9297bac5b/guestCustomizationSection/" ovf:required="false" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.dmtf.org/ovf/envelope/1 http://schemas.dmtf.org/ovf/envelope/1/dsp8023_1.1.0.xsd http://www.vmware.com/vcloud/v1.5 http://zone01.bluelock.com/api/v1.5/schema/master.xsd">
<ovf:Info>Specifies Guest OS Customization Settings</ovf:Info>
<Enabled>true</Enabled>
<CustomizationScript>#{CGI.escapeHTML(vmdata[:CustomizationScript])}</CustomizationScript>
<ComputerName>#{vmdata[:ComputerName]}</ComputerName>

<Link rel="edit" type="application/vnd.vmware.vcloud.guestCustomizationSection+xml" href="#{edit_uri}"/>
</GuestCustomizationSection>
EOF
          request(
            :body     => body,
            :expects  => 202,
            :headers  => {'Content-Type' => vmdata[:type] },
            :method   => 'PUT',
            :uri      => "#{edit_uri}",
            :parse    => true
          )
        end
      end
    end
  end
end
