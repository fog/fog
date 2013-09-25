require 'fog/core/collection'
require 'fog/linode/models/compute/stack_script'

module Fog
  module Compute
    class Linode
      class StackScripts < Fog::Collection
        model Fog::Compute::Linode::StackScript

        def all
          load stackscripts
        end

        def get(id)
          new stackscripts(id).first
        rescue Fog::Compute::Linode::NotFound
          nil
        end

        private
        def stackscripts(id=nil)
          service.stackscript_list(id).body['DATA'].map { |script| map_stackscript script }
        end

        def map_stackscript(script)
          script = script.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          script.merge! :id => script[:stackscriptid], :name => script[:label]
        end
      end
    end
  end
end
