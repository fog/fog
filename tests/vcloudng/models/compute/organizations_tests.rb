require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

VCR.use_cassette(File.basename(__FILE__)) do
  
  Shindo.tests("Compute::Vcloudng | organizations", ['all']) do
    pending if Fog.mocking?
    organizations = vcloudng.organizations
    tests("#There is one organization").returns(1){ organizations.size }
    
    org = organizations.first
    
    tests("Compute::Vcloudng | organization") do
      tests("#name").returns("DevOps"){ org.name }
      tests("#type").returns("application/vnd.vmware.vcloud.org+xml"){ org.type }
    end
    
    tests("Compute::Vcloudng | organization", ['get']) do
      tests("#get_by_name").returns(org.name) { organizations.get_by_name(org.name).name }
      tests("#get").returns(org.id) { organizations.get(org.id).id }
    end
  end
end