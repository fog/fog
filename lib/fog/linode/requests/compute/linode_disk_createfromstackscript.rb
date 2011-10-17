module Fog
  module Compute
    class Linode
      class Real

        def linode_disk_createfromstackscript(linode_id, script_id, distro_id, name, size, password, options={})
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.disk.createfromstackscript',
              :linodeId => linode_id,
              :stackScriptID => script_id,
              :distributionId => distro_id,
              :label => name,
              :size => size,
              :rootPass => password,
              :stackScriptUDFResponses => MultiJson.encode(options)
            }
          )
        end

      end
    end
  end
end
