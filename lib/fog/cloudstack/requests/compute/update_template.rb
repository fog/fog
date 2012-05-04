module Fog
  module Compute
    class Cloudstack
      class Real

        # Updates attributes of a template
        #
        # ==== Parameters
        # * id<~Integer>: The ID of the image file
        # * options<~Hash>: A hash of optional parameters, see the documentation below for details
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/updateTemplate.html]
        def update_template(id, options={})
          options.merge!(
            'command' => 'updateTemplate',
            'id'      => id
          )

          request(options)
        end
      end

      class Mock
        def update_template(id, options={})
          {
            "updatetemplateresponse" =>{
              "template" =>{
                "ostypename"  =>"CentOS 5.5 (64-bit)",
                "name"        =>"FogRegisterTest",
                "hypervisor"  =>"XenServer",
                "format"      =>"VHD",
                "ispublic"    =>false,
                "domain"      =>"ROOT",
                "account"     =>"admin",
                "isfeatured"  =>false,
                "displaytext" =>"FogRegisterTest",
                "ostypeid"    =>112,
                "isready"     =>false,
                "id"          =>213,
                "domainid"    =>1,
                "crossZones"  =>false,
                "created"     =>"2012-03-30T01:01:44+0000"
              }
            }
          }
        end
      end
    end
  end
end