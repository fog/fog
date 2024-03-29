# necessary when requiring fog without rubygems while also
# maintaining ruby 1.8.7 support (can't use require_relative)
__LIB_DIR__ = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift __LIB_DIR__ unless $LOAD_PATH.include?(__LIB_DIR__)

require 'fog/version'

# Use core
require 'fog/core'

# Previously treated as "core"
# data exchange specific (to be extracted and used on a per provider basis)
require 'fog/xml'
require 'fog/json'

# deprecation wrappers (XML wrapped version)
require 'fog/core/deprecated/connection'
require 'fog/core/deprecated_connection_accessors'

# any one of these can be required separately.
# they all depend on fog/core for shared functionality.
require 'fog/aws'
require 'fog/brightbox'
require 'fog/clodo'
require 'fog/cloudstack'
require 'fog/digitalocean'
require 'fog/dnsimple'
require 'fog/dnsmadeeasy'
require 'fog/fogdocker'
require 'fog/dreamhost'
require 'fog/dynect'
require 'fog/glesys'
require 'fog/go_grid'
require 'fog/google'
require 'fog/ibm'
require 'fog/internet_archive'
require 'fog/linode'
require 'fog/local'
require 'fog/bare_metal_cloud'
require 'fog/rackspace'
require 'fog/rage4'
require 'fog/riakcs'
require 'fog/openstack'
require 'fog/ovirt'
require 'fog/powerdns'
require 'fog/profitbricks'
require 'fog/sakuracloud'
require 'fog/softlayer'
require 'fog/storm_on_demand'
require 'fog/vcloud'
require 'fog/vcloud_director'
require 'fog/vmfusion'
require 'fog/vsphere'
require 'fog/voxel'
require 'fog/xenserver'
require 'fog/cloudsigma'
require 'fog/openvz'
require 'fog/opennebula'
require 'fog/aliyun'
