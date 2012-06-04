require 'fog/core/collection'
require 'fog/aws/models/iam/access_key'

module Fog
  module AWS
    class IAM

      class AccessKeys < Fog::Collection
        attribute :user
        attribute :filters
        
        
        model Fog::AWS::IAM::AccessKey
        
        def initialize(attributes)
          self.filters ||= {}
          if attributes[:user]
            filters[:identifier] = attributes[:user].id
          else
            raise ArgumentError.new("Can't get a user's access_key without a user.id")
          end
          super
        end
        

        def all 
          data = connection.list_access_keys('UserName'=> filters[:identifier]).body['AccessKeys']
          # AWS response doesn't contain the UserName, this injects it
          data.each {|access_key| access_key['UserName'] = filters[:identifier] }
          load(data)
        end

        def get(identity)
          self.all.select {|access_key| access_key.id == identity}.first
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