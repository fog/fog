module Fog
  module Compute
    class Linode
      class Real
        def linode_config_list(linode_id, config_id=nil, options={})
          if config_id
            options.merge!(:configid => config_id)
          end
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.config.list', :linodeId => linode_id }.merge!(options)
          )
        end
      end

      class Mock
        def linode_config_list(linode_id, config_id=nil, options={})
          response = Excon::Response.new
          response.status = 200

          body = {
            "ERRORARRAY" => [],
            "ACTION" => "linode.config.list"
          }
          if config_id
            mock_config = create_mock_config(linode_id, config_id)
            response.body = body.merge("DATA" => [mock_config])
          else
            mock_configs = []
            5.times do
              linode_id = rand(10000..99999)
              config_id = rand(10000..99999)
              mock_configs << create_mock_config(linode_id, config_id)
            end
            response.body = body.merge("DATA" => mock_configs)
          end
          response
        end

        private

        def create_mock_config(linode_id, config_id)
          {
            "Comments"               => "",
            "ConfigID"               => config_id,
            "DiskList"               => "839421,839420,,,,,,,",
            "KernelID"               => 137,
            "Label"                  => "test_#{linode_id}",
            "LinodeID"               => linode_id,
            "RAMLimit"               => 0,
            "RootDeviceCustom"       => "",
            "RootDeviceNum"          => 1,
            "RootDeviceRO"           => true,
            "RunLevel"               => "default",
            "__validationErrorArray" => [],
            "apiColumnFilterStruct"  => "",
            "devtmpfs_automount"     => true,
            "helper_depmod"          => 1,
            "helper_disableUpdateDB" => 1,
            "helper_libtls"          => 0,
            "helper_xen"             => 1,
            "isRescue"               => 0
          }
        end
      end
    end
  end
end
