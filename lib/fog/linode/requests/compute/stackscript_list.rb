module Fog
  module Compute
    class Linode
      class Real
        # Get available stack scripts
        #
        # ==== Parameters
        # * scriptId<~Integer>: id to limit results to
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def stackscript_list(script_id=nil)
          options = {}
          if script_id
            options.merge!(:stackScriptID => script_id)
          end
          result = request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'stackscript.list' }.merge!(options)
          )
          result.body['DATA'].each { |r| r['DISTRIBUTIONIDLIST'] = r['DISTRIBUTIONIDLIST'].to_s }
          result
        end
      end
    end
  end
end
