module Fog
  module Compute
    class AWS
      class Real
        require 'fog/aws/parsers/compute/basic'

        # Adds tags to resources
        #
        # ==== Parameters
        # * resources<~String> - One or more resources to tag
        # * tags<~String> - hash of key value tag pairs to assign
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-CreateTags.html]
        def create_tags(resources, tags)
          resources = [*resources]
          for key, value in tags
            if value.nil?
              tags[key] = ''
            end
          end
          params = {}
          params.merge!(Fog::AWS.indexed_param('ResourceId', resources))
          params.merge!(Fog::AWS.indexed_param('Tag.%d.Key', tags.keys))
          params.merge!(Fog::AWS.indexed_param('Tag.%d.Value', tags.values))
          request({
            'Action'    => 'CreateTags',
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::Basic.new
          }.merge!(params))
        end
      end

      class Mock
        MOCK_TAG_TYPES = {
          'ami' => 'image',
          'i' => 'instance',
          'snap' => 'snapshot',
          'vol' => 'volume',
          'igw' => 'internet_gateway',
          'acl' => 'network_acl',
          'vpc' => 'vpc'
        }

        def create_tags(resources, tags)
          resources = [*resources]

          tagged = resources.map do |resource_id|
            if match = resource_id.match(/^(\w+)-[a-z0-9]{8}/i)
              id = match.captures.first
            else
              raise(Fog::Service::NotFound.new("Unknown resource id #{resource_id}"))
            end

            if MOCK_TAG_TYPES.has_key? id
              type = MOCK_TAG_TYPES[id]
            else
              raise(Fog::Service::NotFound.new("Mocking tags of resource #{resource_id} has not been implemented"))
            end

            case type
              when 'image'
                unless visible_images.has_key? resource_id
                 raise(Fog::Service::NotFound.new("Cannot tag #{resource_id}, the image does not exist"))
                end
              when 'vpc'
                if self.data[:vpcs].select {|v| v['vpcId'] == resource_id }.empty?
                  raise(Fog::Service::NotFound.new("Cannot tag #{resource_id}, the vpc does not exist"))
                end
              else
                unless self.data[:"#{type}s"][resource_id]
                 raise(Fog::Service::NotFound.new("Cannot tag #{resource_id}, the #{type} does not exist"))
                end
            end
            { 'resourceId' => resource_id, 'resourceType' => type }
          end

          tags.each do |key, value|
            self.data[:tags][key] ||= {}
            self.data[:tags][key][value] ||= []
            self.data[:tags][key][value] |= tagged

            tagged.each do |resource|
              self.data[:tag_sets][resource['resourceId']][key] = value
            end
          end

          response = Excon::Response.new
          response.status = 200
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
