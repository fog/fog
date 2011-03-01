module Fog
  module Linode
    class Compute
      class Real
        def stackscript_list(script_id=nil)
          options = {}
          if script_id
            options.merge!(:stackScriptID => script_id)
          end          
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'stackscript.list' }.merge!(options)
          )
        end
      end
    end
  end
end
