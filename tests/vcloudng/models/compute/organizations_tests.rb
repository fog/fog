require_relative './helper.rb'

VCR.use_cassette(File.basename(__FILE__)) do
  
  Shindo.tests("Compute::Vcloudng | organizations", ['vcloudng']) do
    pending if Fog.mocking?
    organizations = vcloudng.organizations
    tests("#There is one organization").returns(1){ organizations.size }
    tests("Compute::Vcloudng | organization") do
      org = organizations.first
      tests("#name").returns("DevOps"){ org.name }
      tests("#type").returns("application/vnd.vmware.vcloud.org+xml"){ org.type }
    end
  end
end