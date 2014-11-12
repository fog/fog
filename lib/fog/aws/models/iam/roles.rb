require 'fog/core/collection'
require 'fog/aws/models/iam/role'

module Fog
  module AWS
    class IAM
      class Roles < Fog::Collection
        model Fog::AWS::IAM::Role

        def initialize(attributes = {})
          super
        end

        def all
          data = service.list_roles.body['Roles']
          load(data)
        end

        def get(identity)
          role = nil
          begin
            role = service.roles.new( service.get_role( identity ).data[:body]["Role"] )
          rescue Excon::Errors::NotFound, Fog::AWS::IAM::NotFound # ignore not found error
          end
          role
        end

        def new(attributes = {})
          if not attributes.key?(:assume_role_policy_document)
            attributes[:assume_role_policy_document] = Fog::AWS::IAM::EC2_ASSUME_ROLE_POLICY.to_s
          end
          super
        end
      end
    end
  end
end
