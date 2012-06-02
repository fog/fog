require 'fog/core/collection'
require 'fog/aws/models/iam/policy'

module Fog
  module AWS
    class IAM

      class Policies < Fog::Collection
        attribute :user
        attribute :filters
        
        
        model Fog::AWS::IAM::Policy
        
        def initialize(attributes)
          self.filters ||= {}
          if attributes[:user]
            filters[:identifier] = attributes[:user].id
          else
            raise ArgumentError.new("Can't get a policy's user without a user.id")
          end
          super
        end
        

        def all
          # AWS method get_user_policy only returns an array of policy names, this is kind of useless, 
          # that's why it has to loop through the list to get the details of each element. I don't like it because it makes this method slow
          policy_names = connection.list_user_policies(filters[:identifier]).body['PolicyNames'] # it returns an array
          policies = []
          policy_names.each do |policy_name|
            policies << connection.get_user_policy(policy_name,filters[:identifier]).body
          end
          load(policies) # data is an array of attribute hashes
        end

        def get(identity)
          data = connection.get_user_policy(identity,filters[:identifier]).body
          new(data) # data is an attribute hash
        rescue Fog::AWS::IAM::NotFound
          nil
        end
        
        def new(attributes = {})
          if user
            super({ :username => user.id }.merge!(attributes))
          else
            super
          end
        end

      end
    end
  end
end