require 'fog/core/model'
require 'fog/rackspace/models/dns/records'

module Fog
  module DNS
    class Rackspace

      class Zone < Fog::Model
        include Fog::DNS::Rackspace::Callback

        identity :id

        attribute :email,       :aliases => 'emailAddress'
        attribute :domain,      :aliases => 'name'
        attribute :created
        attribute :updated
        attribute :account_id,  :aliases => 'accountId'
        attribute :ttl
        attribute :nameservers
        attribute :comment

        def destroy
          response = connection.remove_domain(identity)
          wait_for_job response.body['jobId'], Fog.timeout
          true
        end

        def records
          @records ||= begin
            Fog::DNS::Rackspace::Records.new(
              :zone       => self,
              :connection => connection
            )
          end
        end

        def save
          if identity
            update
          else
            create
          end
          true
        end

        private

        def create
          requires :domain, :email

          data = { :name => domain, :email => email }
          response = connection.create_domains([data])

          response = wait_for_job response.body['jobId']
          merge_attributes(response.body['domains'].first)
        end

        def update
          requires :ttl, :email

          response = connection.modify_domain(identity, { :ttl => ttl, :comment => comment, :email => email})
          wait_for_job response.body['jobId']
        end
      end
    end
  end
end
