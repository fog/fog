require 'vcr'
require 'fog/vcloud_director/compute'

VCR.configure do |c|
  c.cassette_library_dir = 'tests/vcloud_director/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

def boolean?(item)
  [TrueClass, FalseClass].include?(item.class)
end

def vcloud_director 
  @vcloud_director ||= Fog::Compute::VcloudDirector.new(:vcloud_director_username => "#{ENV['IMEDIDATA_COM_USERNAME']}@devops", 
                                           :vcloud_director_password => ENV['IMEDIDATA_COM_PASSWORD'], 
                                           :vcloud_director_host => 'devlab.mdsol.com',
                                           :vcloud_director_api_version => '5.1',
                                           :connection_options => {
                                                                    :ssl_verify_peer => false, 
                                                                    :connect_timeout => 200, 
                                                                    :read_timeout => 200 
                                                                   } 
                                          )
end

def organizations 
  @organizations ||= vcloud_director.organizations
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


def the_network
  @network ||= organization.networks.get_by_name(NETWORK_NAME)
end    
  
def the_catalog
  @catalog ||= organization.catalogs.get_by_name(CATALOG_NAME)
end
  
def the_catalog_item
  return nil unless the_catalog
  @catalog_item ||= the_catalog.catalog_items.get_by_name(CATALOG_ITEM_NAME)
end
