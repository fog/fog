require 'fog/orchestration/models/stacks'
require 'fog/aws/models/orchestration/stack'

module Fog
  module Orchestration
    class AWS
      # General use helper methods
      module Common

        # Fetch all available results when result set may be paged
        #
        # @param result_key [String] key in body hash of result
        # @param next_token [String] next page token
        # @yield block to return Excon result
        # @yieldparam options [Hash] request options hash
        # @return [Array]
        def fetch_paged_results(result_key, next_token=nil, &block)
          list = []
          options = next_token ? {'NextToken' => next_token} : {}
          result = block.call(options)
          list += result.body[result_key]
          if(token = result.body['NextToken'])
            list += fetch_paged_results(result_key, token, &block)
          end
          list
        end


      end

    end
  end
end
