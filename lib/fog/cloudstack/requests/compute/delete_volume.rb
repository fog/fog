module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a detached disk volume.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteVolume.html]
        def delete_volume(id, options={})
          options.merge!(
            'command' => 'deleteVolume', 
            'id' => id  
          )
          request(options)
        end
      end
 
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
      end 
    end
  end
end

