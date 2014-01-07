module Fog
  module Compute
    class Cloudstack
      class Real

        # Disable static nat.
        #
        # {CloudStack API Reference}[http://incubator.apache.org/cloudstack/docs/api/apidocs-4.0.0/root_admin/disableStaticNat.html]
        def disable_static_nat(options={})
          options.merge!(
              'command' => 'disableStaticNat'
          )

          request(options)
        end

      end

      class Mock
        # Disable static nat mock.
        #
        # {CloudStack API Reference}[http://incubator.apache.org/cloudstack/docs/api/apidocs-4.0.0/root_admin/disableStaticNat.html]
        def disable_static_nat(options={})
          { 'disablestaticnatresponse' =>
                { 'count' => 2,
                  'nat_info' => {
                     'displaytext' => 'displaytext',
                     'success'     => true
                  }
                }
          }
 
        end
 
      end
    end
  end
end
