  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # load template into primary storage
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/prepareTemplate.html]
          def prepare_template(options={})
            options.merge!(
              'command' => 'prepareTemplate'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
