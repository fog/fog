module Fog
  module Compute
    class Cloudstack
      class Real
        def create_template(options={})
          options.merge!(
              'command' => 'createTemplate'
          )

          request(options)
        end
      end
    end
  end
end

