module Fog
  module Compute
    class Cloudstack
      class Real

        # Enable static nat.
        #
        # {CloudStack API Reference}[http://incubator.apache.org/cloudstack/docs/api/apidocs-4.0.0/root_admin/enableStaticNat.html]
        def enable_static_nat(options={})
          options.merge!(
              'command' => 'enableStaticNat'
          )

          request(options)
        end

      end
     
     class Mock

        # Enable static nat mock.
        #
        # {CloudStack API Reference}[http://incubator.apache.org/cloudstack/docs/api/apidocs-4.0.0/root_admin/enableStaticNat.html]
        def enable_static_nat(options={})
          { 'enablestaticnatresponse' =>
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
