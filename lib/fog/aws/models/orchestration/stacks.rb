require 'fog/orchestration/models/stacks'
require 'fog/aws/models/orchestration/stack'

module Fog
  module Orchestration
    class AWS
      class Stacks < Fog::Orchestration::Stacks

        model Fog::Orchestration::AWS::Stack

        attribute :filters

        def initialize(attributes)
          self.filters = {}
          super
        end

        def all
          unless(attributes['Stacks'])
            attributes['Stacks'] = fetch_stacks
          end
          load(attributes['Stacks'])
        end

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

        def fetch_stacks
          describe = fetch_paged_results('Stacks') do |options|
            service.describe_stacks(options)
          end
          list = fetch_paged_results('StackSummaries') do |options|
            service.list_stacks(options.merge(self.filters))
          end
          stack_defs = list.map do |stack_hash|
            desc_hash = describe.detect{|h| h['StackId'] == stack_hash['StackId']}
            stack_hash.merge!(desc_hash) if desc_hash
            stack_hash
          end
        end

        def find_by_name(name)
          self.find{|stack| stack.stack_name == name}
        end

      end
    end
  end
end
