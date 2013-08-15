require 'vcr'
require 'fog/vcloudng/compute'

VCR.configure do |c|
  c.cassette_library_dir = 'tests/vcloudng/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

VCR.use_cassette(File.basename(__FILE__)) do
  vcloudng = Fog::Compute::Vcloudng.new(vcloudng_username: "#{ENV['IMEDIDATA_COM_USERNAME']}@devops", vcloudng_password: ENV['IMEDIDATA_COM_PASSWORD'], vcloudng_host: 'devlab.mdsol.com', :connection_options => {:ssl_verify_peer => false, :connect_timeout => 200, :read_timeout => 200 } )
  
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