Shindo.tests('Compute::VcloudDirector | organization requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_organizations').data_matches_schema(VcloudDirector::Compute::Schema::ORG_LIST_TYPE) do
    @org_list = @service.get_organizations.body
  end

  tests('#get_organization').data_matches_schema(VcloudDirector::Compute::Schema::ORG_TYPE) do
    org = @org_list[:Org].detect {|o| o[:name] == @service.org_name}
    @org_uuid = org[:href].split('/').last
    body = @service.get_organization(@org_uuid).body
    require 'pp'
    pp body
    body
  end

  tests('#get_organization_metadata').data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
    pending if Fog.mocking?
    @service.get_organization_metadata(@org_uuid).body
  end

  tests('retrieve non-existent Org').raises(Excon::Errors::Forbidden) do
    @service.get_organization('00000000-0000-0000-0000-000000000000')
  end

end
