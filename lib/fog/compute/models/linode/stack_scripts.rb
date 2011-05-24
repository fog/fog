require 'fog/core/collection'
require 'fog/compute/models/linode/stack_script'

module Fog
  module Linode
    class Compute
      class StackScripts < Fog::Collection
        model Fog::Linode::Compute::StackScript

        def all
          load stackscripts
        end

        def get(id)
          new stackscripts(id).first
        rescue Fog::Linode::Compute::NotFound
          nil
        end        

        private
        def stackscripts(id=nil)
          connection.stackscript_list(id).body['DATA'].map { |script| map_stackscript script }
        end
        
        def map_stackscript(script)
          script = script.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          script.merge! :id => script[:stackscriptid], :name => script[:label]
        end
      end
    end
  end
end
