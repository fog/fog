require 'fog/orchestration/models/stacks'
require 'fog/aws/models/orchestration/stack'
require 'fog/aws/models/orchestration/common'

module Fog
  module Orchestration
    class AWS
      # Stacks list
      class Stacks < Fog::Orchestration::Stacks

        include Fog::Orchestration::AWS::Common

        # Register the stack model class
        model Fog::Orchestration::AWS::Stack

        # @return [Hash] filters to apply to stack list
        attr_accessor :filters

        def initialize(args={})
          self.filters = args.delete(:filters) || {}
          super
        end

        # Load all stacks
        #
        # @return [self]
        def all
          unless(attributes['Stacks'])
            attributes['Stacks'] = fetch_stacks
          end
          load(attributes['Stacks'])
        end

        # Fetch all stacks
        #
        # @return [Array<Hash>] stacks
        # @note this combines describe_stacks with list_stacks to grab
        #       as much data as possible with the fewest API calls
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

      end
    end
  end
end
