module Fog
  module TerremarkEcloud
    class Compute
      class Real

        require 'fog/compute/parsers/terremark_ecloud/login'

        def login
          connection = Fog::Connection.new(@login_url)
          response   = connection.request({
            :expects => 200,
            :method  => 'POST',
            :headers => {
              'Authorization' => ('Basic ' << Base64.encode64("#{@username}:#{@password}").chomp!),
              'Content-Type'  => 'application/vnd.vmware.vcloud.orgList+xml'
            },
            :parser   => Fog::Parsers::TerremarkEcloud::Compute::Login.new
          })
          @token = response.headers['Set-Cookie']
          response
        end

      end
    end
  end
end
