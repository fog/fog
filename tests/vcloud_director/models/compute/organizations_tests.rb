require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

Shindo.tests("Compute::VcloudDirector | organizations", ['vclouddirector', 'all']) do
  organizations = vcloud_director.organizations
  tests("#There is at least one organization").returns(true) { organizations.size >= 1 }

  org = organizations.get_by_name(vcloud_director.org_name)

  tests("Compute::VcloudDirector | organization") do
    tests("#name").returns(String) { org.name.class }
    tests("#type").returns("application/vnd.vmware.vcloud.org+xml") { org.type }
  end

  tests("Compute::VcloudDirector | organization", ['get']) do
    tests("#get_by_name").returns(org.name) { organizations.get_by_name(org.name).name }
    tests("#get").returns(org.id) { organizations.get(org.id).id }
  end
end
