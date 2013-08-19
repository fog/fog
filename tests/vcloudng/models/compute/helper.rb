require 'vcr'
require 'fog/vcloudng/compute'

VCR.configure do |c|
  c.cassette_library_dir = 'tests/vcloudng/vcr_cassettes'
  c.hook_into :webmock
end

def vcloudng 
  @vcloudng ||= Fog::Compute::Vcloudng.new(vcloudng_username: "#{ENV['IMEDIDATA_COM_USERNAME']}@devops", 
                                           vcloudng_password: ENV['IMEDIDATA_COM_PASSWORD'], 
                                           vcloudng_host: 'devlab.mdsol.com', 
                                           :connection_options => {
                                                                    :ssl_verify_peer => false, 
                                                                    :connect_timeout => 200, 
                                                                    :read_timeout => 200 
                                                                   } 
                                          )
end

def organizations 
  @organizations ||= vcloudng.organizations
end

def organization
  organizations.first
end

def catalogs
  @catalogs ||= organization.catalogs
end

def catalog
  catalogs.first
end

def vdcs
  @vdcs ||= organization.vdcs
end

def vdc
  vdcs.first
end

def vapps
  @vapps ||= vdc.vapps
end

def vapp
  vapps.detect {|vapp| vapp.vms.size >= 1 }
end