require 'fog/core/model'
#require 'fog/dns/models/rackspace/records'

module Fog
  module DNS
    class Rackspace

      class Zone < Fog::Model

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
          response = connection.delete_domain(identity)
          wait_for_job response.body['jobId'], Fog.timeout
          true
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

        def wait_for_job(job_id, timeout=Fog.timeout, interval=1)
          retries = 5
          response = nil
          Fog.wait_for(timeout, interval) do
            response = connection.callback job_id
            if response.status != 202
              true
            elsif retries == 0
              raise Fog::Errors::Error.new("Wait on job #{job_id} took too long")
            else
              retries -= 1
              false
            end
          end
          response
        end

        def create
          requires :domain

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
