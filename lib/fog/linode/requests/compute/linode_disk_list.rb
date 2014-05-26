module Fog
  module Compute
    class Linode
      class Real
        def linode_disk_list(linode_id, disk_id=nil)
          options = {}
          if disk_id
            options.merge!(:diskId => disk_id)
          end
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.disk.list', :linodeId => linode_id }.merge!(options)
          )
        end
      end

      class Mock
        def linode_disk_list(linode_id, disk_id=nil)
          response = Excon::Response.new
          response.status = 200
          body = {
            "ERRORARRAY" => [],
            "ACTION" => "linode.disk.list"
          }
          if disk_id
            mock_disk = create_mock_disk(linode_id, disk_id)
            response.body = body.merge("DATA" => [mock_disk])
          else
            mock_disks = []
            2.times do
              disk_id = rand(10000..99999)
              mock_disks << create_mock_disk(linode_id, disk_id)
            end
            response.body = body.merge("DATA" => mock_disks)
          end
          response
        end

        private

        def create_mock_disk(linode_id, disk_id)
          {
            "CREATE_DT"  => "2012-02-29 12:55:29.0",
            "DISKID"     => disk_id,
            "ISREADONLY" => 0,
            "LABEL"      => "test_#{linode_id}_main",
            "LINODEID"   => linode_id,
            "SIZE"       => 39936,
            "STATUS"     => 1,
            "TYPE"       => "ext3",
            "UPDATE_DT"  => "2012-02-29 12:55:53.0"
          }
        end
      end
    end
  end
end
