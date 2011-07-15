# -*- coding: utf-8 -*-
module Fog
  module Vcloud
    class Compute
      class Real

        def configure_vm_name_description(edit_href, name, description)

          body = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<VApp xmlns="http://www.vmware.com/vcloud/v1" name="#{name}" type="application/vnd.vmware.vcloud.vApp+xml">
    <Description>#{description}</Description>
</VApp>
EOF

          request(
            :body     => body,
            :expects  => 202,
            :headers  => {'Content-Type' => "application/vnd.vmware.vcloud.vApp+xml"},
            :method   => 'PUT',
            :uri      => edit_href,
            :parse    => true
          )
        end

      end

    end
  end
end
