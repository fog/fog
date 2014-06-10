require 'fog/vcloud_director/compute'

def boolean?(item)
  [TrueClass, FalseClass].include?(item.class)
end

def vcloud_director
  @vcloud_director ||= Fog::Compute::VcloudDirector.new(
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
  @organization ||= organizations.get_by_name(vcloud_director.org_name)
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
  vapps.find {|vapp| vapp.vms.size >= 1 }
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
