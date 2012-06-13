module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a specified user.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/deleteVolume.html]
        def delete_volume(options={})
          options.merge!(
            'command' => 'deleteVolume'
          )

          request(options)
        end

      end # Real
      class Mock
        def delete_volume(options={})
          volume_id = options['id']
          if self.data[:volumes][volume_id]
            self.data[:volumes].delete(volume_id)
            {
              "deletevolumeresponse" => {
                "success" => "true"
              }
            }
          else # FIXME: mayhaps
            self.data[:volumes].delete(volume_id)
            {
              "deletevolumeresponse" => {
                "success" => "false"
              }
            }
          end
        end
      end # Mock
    end # Cloudstack
  end # Compute
end # Fog
