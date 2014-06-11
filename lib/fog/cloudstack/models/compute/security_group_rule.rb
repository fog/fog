module Fog
  module Compute
    class Cloudstack
      class SecurityGroupRule < Fog::Model
        identity  :id,                :aliases => 'ruleid'

        attribute :security_group_id, :type => :string
        attribute :protocol,          :type => :string
        attribute :start_port,        :type => :integer, :aliases => 'startport'
        attribute :end_port,          :type => :integer, :aliases => 'endport'
        attribute :cidr,              :type => :string
        attribute :direction,         :type => :string

        def destroy
          data = service.send("revoke_security_group_#{self.direction}", "id" => self.id)
          job = service.jobs.new(data["revokesecuritygroup#{self.direction}"])
          job.wait_for { ready? }
          job.successful?
        end

        def port_range
          (self.start_port..self.end_port)
        end

        def save
          requires :security_group_id, :cidr, :direction

          data = service.send("authorize_security_group_#{self.direction}".to_sym, params)
          job = service.jobs.new(data["authorizesecuritygroup#{self.direction}response"])
          job.wait_for { ready? }
          # durty
          merge_attributes(job.result.send("#{self.direction}_rules").last)
          self
        end

        def security_group
          service.security_groups.get(self.security_group_id)
        end

        def reload
          requires :id, :security_group_id, :cidr

          merge_attributes(security_group.rules.get(self.id))
        end

        private

        def params
          options = {
            "securitygroupid" => self.security_group_id,
            "protocol"        => self.protocol,
            "cidrlist"        => self.cidr
          }
          options.merge!("startport" => self.start_port) unless self.start_port.nil?
          options.merge("endport" => self.end_port) unless self.end_port.nil?
        end
      end # SecurityGroupRule
    end # Cloudstack
  end # Compute
end # Fog
