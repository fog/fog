module Fog
  module Vcloud
    module Terremark
      module Ecloud
        module Real

          # See /lib/fog/vcloud/requests/get_organizations.rb
          def login
            unauthenticated_request({
              :expects  => 200,
              :headers  => {
                'Authorization' => authorization_header,
                'Content-Type'  => "application/vnd.vmware.vcloud.orgList+xml"
              },
              :method   => 'POST',
              :parser   => Fog::Parsers::Vcloud::Login.new,
              :uri      => @login_uri
            })
          end

        end
      end
    end
  end
end


