require 'fog/openstack/models/collection'
require 'fog/openstack/models/identity_v3/service'

module Fog
  module Identity
    class OpenStack
      class V3
        class Tokens < Fog::OpenStack::Collection
          model Fog::Identity::OpenStack::V3::Token


          def authenticate(auth)
            @@cache ||= {}
            response = service.token_authenticate(auth)
            token_hash = response.body['token']
            Fog::Identity::OpenStack::V3::Token.new(
                token_hash.merge(:service => service, :value => response.headers['X-Subject-Token']))
          end

          def validate(subject_token)
            response = service.token_validate(subject_token)
            token_hash = response.body['token']
            Fog::Identity::OpenStack::V3::Token.new(
                token_hash.merge(:service => service, :value => response.headers['X-Subject-Token']))
          end

          def check(subject_token)
            service.token_check(subject_token)
            return true
          end

          def revoke(subject_token)
            service.token_revoke(subject_token)
            return true
          end

        end
      end
    end
  end
end
