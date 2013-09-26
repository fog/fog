Shindo.tests('Compute::VcloudDirector | organization requests', ['vclouddirector']) do

  ORG_LIST_FORMAT = {
    :xmlns => 'http://www.vmware.com/vcloud/v1.5',
    :xmlns_xsi => 'http://www.w3.org/2001/XMLSchema-instance',
    :type => 'application/vnd.vmware.vcloud.orgList+xml',
    :href => String,
    :xsi_schemaLocation => String,
    :Org => [{
      :type => 'application/vnd.vmware.vcloud.org+xml',
      :name => String,
      :href => String
    }]
  }

  ORG_FORMAT = {
    :xmlns => 'http://www.vmware.com/vcloud/v1.5',
    :xmlns_xsi => 'http://www.w3.org/2001/XMLSchema-instance',
    :name => String,
    :id => String,
    :type => 'application/vnd.vmware.vcloud.org+xml',
    :href => String,
    :xsi_schemaLocation => String,
    :Link => [{
      :rel => String,
      :type => String,
    # :name => String, -- not always true
      :href => String,
    }],
    :Description => String,
    :FullName => String
  }

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_organizations').formats(ORG_LIST_FORMAT) do
    @org_list = @service.get_organizations.body
    @org_list[:Org] = [@org_list[:Org]] if @org_list[:Org].is_a?(Hash)
    @org_list
  end

  tests('#get_organization').formats(ORG_FORMAT) do
    org = @org_list[:Org].detect {|o| o[:name] == @service.org_name}
    org_uuid = org[:href].split('/').last
    @service.get_organization(org_uuid).body
  end

end
