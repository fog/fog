require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

VCR.use_cassette(File.basename(__FILE__)) do
  
  Shindo.tests("Compute::VcloudDirector | organizations", ['all']) do
    pending if Fog.mocking?
    organizations = vcloud_director.organizations
    tests("#There is one organization").returns(1){ organizations.size }
    
    org = organizations.first
    
    tests("Compute::VcloudDirector | organization") do
      tests("#name").returns("DevOps"){ org.name }
      tests("#type").returns("application/vnd.vmware.vcloud.org+xml"){ org.type }
    end
    
    tests("Compute::VcloudDirector | organization", ['get']) do
      tests("#get_by_name").returns(org.name) { organizations.get_by_name(org.name).name }
      tests("#get").returns(org.id) { organizations.get(org.id).id }
    end
  end
end