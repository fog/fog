require 'fog/core/collection'
require 'fog/aws/models/iam/policy'

module Fog
  module AWS
    class IAM

      class Policies < Fog::Collection
                
        model Fog::AWS::IAM::Policy
        
        def initialize(attributes = {})
          @username = attributes[:username]
          raise ArgumentError.new("Can't get a policy's user without a username") unless @username
          super
        end
        

        def all
          # AWS method get_user_policy only returns an array of policy names, this is kind of useless, 
          # that's why it has to loop through the list to get the details of each element. I don't like it because it makes this method slow
          policy_names = connection.list_user_policies(@username).body['PolicyNames'] # it returns an array
          policies = []
          policy_names.each do |policy_name|
            policies << connection.get_user_policy(policy_name,@username).body['Policy']
          end
          load(policies) # data is an array of attribute hashes
        end

        def get(identity)
          data = connection.get_user_policy(identity,@username).body['Policy']
          new(data) # data is an attribute hash
        rescue Fog::AWS::IAM::NotFound
          nil
        end
        
        def new(attributes = {})
          super({ :username => @username }.merge!(attributes))
        end
        
      end
    end
  end
end