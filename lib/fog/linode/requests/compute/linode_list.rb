module Fog
  module Compute
    class Linode
      class Real
        # List all linodes user has access or delete to
        #
        # ==== Parameters
        # * linodeId<~Integer>: Limit the list to the specified LinodeID
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def linode_list(linode_id=nil)
          options = {}
          if linode_id
            options.merge!(:linodeId => linode_id)
          end
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.list' }.merge!(options)
          )
        end
      end

      class Mock
        def linode_list(linode_id=nil)
          body = {
            "ERRORARRAY" => [],
            "ACTION" => "linode.list"
          }
          response = Excon::Response.new
          response.status = 200
          if linode_id
            # one server
            mock_server = create_mock_server(linode_id)
            response.body = body.merge("DATA" => [mock_server])
          else
            # all servers
            mock_servers = []
            5.times do
              linode_id = rand(100000..999999)
              mock_servers << create_mock_server(linode_id)
            end
            response.body = body.merge("DATA" => mock_servers)
          end
          response
        end

        private

        def create_mock_server(linode_id)
          { "ALERT_CPU_ENABLED"       => 1,
            "ALERT_BWIN_ENABLED"      => 1,
            "BACKUPSENABLED"          => 0,
            "ALERT_CPU_THRESHOLD"     => 90,
            "ALERT_BWQUOTA_ENABLED"   => 1,
            "LABEL"                   => "test_#{linode_id}",
            "ALERT_DISKIO_THRESHOLD"  => 1000,
            "BACKUPWEEKLYDAY"         => 0,
            "BACKUPWINDOW"            => 0,
            "WATCHDOG"                => 1,
            "DATACENTERID"            => 6,
            "STATUS"                  => 1,
            "ALERT_DISKIO_ENABLED"    => 1,
            "TOTALHD"                 => 40960,
            "LPM_DISPLAYGROUP"        => "",
            "TOTALXFER"               => 400,
            "ALERT_BWQUOTA_THRESHOLD" => 80,
            "TOTALRAM"                => 1024,
            "LINODEID"                => linode_id,
            "ALERT_BWIN_THRESHOLD"    => 5,
            "ALERT_BWOUT_THRESHOLD"   => 5,
            "ALERT_BWOUT_ENABLED"     => 1
          }
        end
      end
    end
  end
end
