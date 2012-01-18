module Fog
  module Vcloud
    class Compute
      class Real
        def undeploy(vapp_uri, save_state = false)
          # builder = Builder::XmlMarkup.new
          # builder.UndeployVAppParams(:xmlns => 'http://www.vmware.com/vcloud/v1',
          #                            :saveState => save_state) {}
          builder = "<UndeployVAppParams saveState=\"#{save_state.to_s}\" xmlns=\"http://www.vmware.com/vcloud/v1\"/>"

          request(
                  :body     => builder,
                  :expects  => 202,
                  :headers  => {'Content-Type' => 'application/vnd.vmware.vcloud.undeployVAppParams+xml' },
                  :method   => 'POST',
                  :uri      => vapp_uri + '/action/undeploy',
                  :parse    => true
                  )
        end
      end
    end
  end
end
