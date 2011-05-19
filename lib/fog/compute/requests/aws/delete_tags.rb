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
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DeleteTags.html]
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
      
      class Mock
        def delete_tags(resources, tags)
          tagged = resources.map do |resource_id|
            type = case resource_id
            when /^ami\-[a-z0-9]{8}$/i
              'image'
            when /^i\-[a-z0-9]{8}$/i
              'instance'
            when /^snap\-[a-z0-9]{8}$/i
              'snapshot'
            when /^vol\-[a-z0-9]{8}$/i
              'volume'
            end
            if type && @data[:"#{type}s"][resource_id]
              { 'resourceId' => resource_id, 'resourceType' => type }
            else
              raise(Fog::Service::NotFound.new("The #{type} ID '#{resource_id}' does not exist"))
            end
          end
          
          tags.each do |key, value|
            @data[:tags][key][value] = @data[:tags][key][value] - tagged
          end
          
          tagged.each do |resource|
            object = @data[:"#{resource['resourceType']}s"][resource['resourceId']]
            tags.each do |key, value|
              tagset = object['tagSet']
              tagset.delete(key) if tagset.has_key?(key) && (value.nil? || tagset[key] == value)
            end
          end
          
          response = Excon::Response.new
          response.status = true
          response.body = {
            'requestId' => Fog::AWS::Mock.request_id,
            'return'    => true
          }
          response
        end
      end
      
    end
  end
end
