module Fog
  module AWS
    class Compute
      class Real

        require 'fog/compute/parsers/aws/basic'

        # Remove tags from resources
        #
        # ==== Parameters
        # * resources<~String> - One or more resources to remove tags from
        # * tags<~String> - hash of key value tag pairs to remove
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def delete_tags(resources, tags)
          resources = [*resources]
          params = {}
          params.merge!(AWS.indexed_param('ResourceId', resources))

          # can not rely on indexed_param because nil values should be omitted
          tags.keys.each_with_index do |key, index|
            index += 1 # should start at 1 instead of 0
            params.merge!("Tag.#{index}.Key" => key)
            unless tags[key].nil?
              params.merge("Tag.#{index}.Value" => tags[key])
            end
          end

          request({
            'Action'            => 'DeleteTags',
            :parser             => Fog::Parsers::AWS::Compute::Basic.new
          }.merge!(params))
        end

      end
    end
  end
end
