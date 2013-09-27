Shindo.tests('Compute::VcloudDirector | organization requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_organizations').data_matches_schema(VcloudDirector::Compute::Schema::ORG_LIST_TYPE) do
    @org_list = @service.get_organizations.body
    @org_list[:Org] = [@org_list[:Org]] if @org_list[:Org].is_a?(Hash)
    @org_list
  end

  tests('#get_organization').data_matches_schema(VcloudDirector::Compute::Schema::ORG_TYPE) do
    org = @org_list[:Org].detect {|o| o[:name] == @service.org_name}
    org_uuid = org[:href].split('/').last
    @service.get_organization(org_uuid).body
  end

  tests('retrieve non-existent Org').raises(Excon::Errors::Forbidden) do
    @service.get_organization('00000000-0000-0000-0000-000000000000')
  end

end
