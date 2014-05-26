module Fog
  module Compute
    class Linode
      class Real
        def linode_ip_list(linode_id, ip_id=nil)
          options = {}
          if ip_id
            options.merge!(:ipaddressId => ip_id)
          end
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.ip.list', :linodeId => linode_id }.merge!(options)
          )
        end
      end

      class Mock
        def linode_ip_list(linode_id, ip_id=nil)
          response = Excon::Response.new
          response.status = 200
          body = {
            "ERRORARRAY" => [],
            "ACTION" => "linode.ip.list"
          }

          if ip_id
            # one IP
            mock_ip = create_mock_ip(ip_id)
            response.body = body.merge("DATA" => [mock_ip])
          else
            # all IPs
            mock_ips = []
            ip_id = rand(10000..99999)
            mock_ips << create_mock_ip(linode_id, ip_id)
            ip_id = rand(10000..99999)
            mock_ips << create_mock_ip(linode_id, ip_id, false)
            response.body = body.merge("DATA" => mock_ips)
          end
          response
        end

        private

        def create_mock_ip(linode_id, ip_id, is_public=true)
          {
            "IPADDRESSID" => ip_id,
            "RDNS_NAME" => "li-test.members.linode.com",
            "LINODEID" => linode_id,
            "ISPUBLIC" => is_public ? 1 : 0,
            "IPADDRESS" => is_public ? "1.2.3.4" : "192.168.1.2"
          }
        end
      end
    end
  end
end
