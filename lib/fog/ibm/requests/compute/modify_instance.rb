module Fog
  module Compute
    class IBM
      class Real
        # Modify an instance
        #
        # ==== Parameters
        # * instance_id<~String> - id of instance to rename
        # * params<~Hash> - depends on type of request
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'success'<~Bool>:
        # OR
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     ????
        #     * 'expirationTime'<~Integer>: new expiration time of instance (epoch)
        #
        #  Note: The feature of dynamically attaching or detaching storage is only
        #  supported by data centers where the KVM host version is RHEL 6.1. If the
        #  feature is not supported by the data center, you will get an exception like
        #  "Unsupported exception. Dynamic features are not supported on the KVM
        #  Host".
        def modify_instance(instance_id, options={})
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/instances/#{instance_id}",
            :body     => options
          )
        end
      end

      class Mock
        def modify_instance(instance_id, params={})
          response = Excon::Response.new
          if instance_exists? instance_id
            if params['state'] == 'restart'
              self.data[:instances][instance_id]["status"] = "8"
              response.status = 200
              response.body   = { "success" => true }
            elsif params['type'] == 'attach' || params['type'] == 'detach'
              if Fog::Storage[:ibm].volume_exists?(params['volume_id'])
                # TODO: Update the instance in the data hash, assuming IBM ever gets this feature working properly.
                response.status = 415
              else
                response.status = 404
              end
            elsif params['name']
              self.data[:instances][instance_id]["name"] = params['name']
              response.status = 200
              response.body = { "success" => true }
            elsif params['expirationTime']
              self.data[:instances][instance_id]["expirationTime"] = params['expirationTime']
              response.status = 200
              response.body = { 'expirationTime' => params['expirationTime'] }
            end
          else
            response.status = 404
          end
          response
        end
      end
    end
  end
end
