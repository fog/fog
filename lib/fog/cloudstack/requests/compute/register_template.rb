module Fog
  module Compute
    class Cloudstack
      class Real

        # Registers an existing template into the Cloud.com cloud.
        #
        # ==== Parameters
        # * displayText<~String>: The display text of the template. This is usually used for display purposes.
        # * format<~String>: The format for the template. Possible values include QCOW2, RAW, and VHD
        # * hypervisor<~String>: The target hypervisor for the template
        # * name<~String>: The name of the template
        # * osTypeId<~Integer>: The ID of the OS Type that best represents the OS of this template.
        # * url<~String>: The URL of where the template is hosted.  Possible URL include http:// and https://
        # * zoneid<~Integer>: The ID of the zone the template is to be hosted on
        # * options<~Hash>: A hash of optional parameters, see the documentation below for details
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/registerTemplate.html]
        def register_template(displayText, format, hypervisor, name, ostypeid, url, zoneid, options={})
          options.merge!(
            'command' => 'registerTemplate',
            'displaytext' => displayText,
            'format' => format,
            'hypervisor' => hypervisor,
            'name' => name,
            'ostypeid' => ostypeid,
            'url' => url,
            'zoneid' => zoneid
          )

          request(options)
        end
      end

      class Mock
        def register_template(displayText, format, hypervisor, name, ostypeid, url, zoneid, options={})
          {
            "registertemplateresponse" => {
              "template" =>
                [
                  {"templatetype"     =>"USER",
                   "ostypename"       =>"CentOS 5.5 (64-bit)",
                   "name"             =>"FogRegisterTest",
                   "hypervisor"       =>"XenServer",
                   "zonename"         =>"rjghome",
                   "format"           =>"VHD",
                   "ispublic"         =>false,
                   "domain"           =>"ROOT",
                   "account"          =>"admin",
                   "isfeatured"       =>false,
                   "displaytext"      =>"FogRegisterTest",
                   "checksum"         =>"f90a36a7455a921f69ccda2d9df5c818",
                   "ostypeid"         =>112,
                   "isready"          =>false,
                   "id"               =>213,
                   "zoneid"           =>1,
                   "passwordenabled"  =>false,
                   "domainid"         =>1,
                   "status"           =>"",
                   "crossZones"       =>false,
                   "isextractable"    =>false,
                   "created"          =>"2012-03-30T01:01:44+0000"}
                ],
               "count"=>1
            }
          }
        end
      end
    end
  end
end