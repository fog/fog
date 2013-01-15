module Fog
  module Compute
    class Cloudstack
      class SecurityGroup < Fog::Model
        identity  :id,            :aliases => 'id'
        attribute :name,                                     :type => :string
        attribute :description,                              :type => :string
        attribute :account,                                  :type => :string
        attribute :domain_id,     :aliases => "domainid",    :type => :string
        attribute :domain_name,   :aliases => "domain",      :type => :string
        attribute :project_id,    :aliases => "projectid",   :type => :string
        attribute :project_name,  :aliases => "project",     :type => :string
        attribute :ingress_rules, :aliases => "ingressrule", :type => :array
        attribute :egress_rules,  :aliases => "egressrule",  :type => :array

        def destroy
          requires :id
          service.delete_security_group('id' => self.id)
          true
        end

        def egress_rules
          attributes[:egress_rules] || []
        end

        def ingress_rules
          attributes[:ingress_rules] || []
        end

        def save
          requires :name

          options = {
            'name'        => self.name,
            'account'     => self.account,
            'description' => self.description,
            'projectid'   => self.project_id,
            'domainid'    => self.domain_id,
          }
          data = service.create_security_group(options)
          merge_attributes(data['createsecuritygroupresponse']['securitygroup'])
        end

        def rules
          service.security_group_rules.all("security_group_id" => self.id)
        end
      end # SecurityGroup
    end # Cloudstack
  end # Compute
end # Fog
