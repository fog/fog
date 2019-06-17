require "spec_helper"
require "fog/bin"

describe Fog do
  describe "#providers" do
    it "includes existing providers" do
      assert_equal "Atmos", Fog.providers[:atmos]
      assert_equal "AWS", Fog.providers[:aws]
      assert_equal "BareMetalCloud", Fog.providers[:baremetalcloud]
      assert_equal "Brightbox", Fog.providers[:brightbox]
      assert_equal "Clodo", Fog.providers[:clodo]
      assert_equal "CloudSigma", Fog.providers[:cloudsigma]
      assert_equal "Cloudstack", Fog.providers[:cloudstack]
      assert_equal "DigitalOcean", Fog.providers[:digitalocean]
      assert_equal "Dnsimple", Fog.providers[:dnsimple]
      assert_equal "DNSMadeEasy", Fog.providers[:dnsmadeeasy]
      assert_equal "Dreamhost", Fog.providers[:dreamhost]
      assert_equal "Dynect", Fog.providers[:dynect]
      assert_equal "Ecloud", Fog.providers[:ecloud]
      assert_equal "Fogdocker", Fog.providers[:fogdocker]
      assert_equal "Glesys", Fog.providers[:glesys]
      assert_equal "GoGrid", Fog.providers[:gogrid]
      assert_equal "Google", Fog.providers[:google]
      assert_equal "IBM", Fog.providers[:ibm]
      assert_equal "InternetArchive", Fog.providers[:internetarchive]
      assert_equal "Linode", Fog.providers[:linode]
      assert_equal "Local", Fog.providers[:local]
      assert_equal "OpenNebula", Fog.providers[:opennebula]
      assert_equal "OpenStack", Fog.providers[:openstack]
      assert_equal "Openvz", Fog.providers[:openvz]
      assert_equal "Ovirt", Fog.providers[:ovirt]
      assert_equal "PowerDNS", Fog.providers[:powerdns]
      assert_equal "ProfitBricks", Fog.providers[:profitbricks]
      assert_equal "Rackspace", Fog.providers[:rackspace]
      assert_equal "Rage4", Fog.providers[:rage4]
      assert_equal "RiakCS", Fog.providers[:riakcs]
      assert_equal "SakuraCloud", Fog.providers[:sakuracloud]
      assert_equal "Serverlove", Fog.providers[:serverlove]
      assert_equal "Softlayer", Fog.providers[:softlayer]
      assert_equal "StormOnDemand", Fog.providers[:stormondemand]
      assert_equal "Vcloud", Fog.providers[:vcloud]
      assert_equal "VcloudDirector", Fog.providers[:vclouddirector]
      assert_equal "Vmfusion", Fog.providers[:vmfusion]
      assert_equal "Voxel", Fog.providers[:voxel]
      assert_equal "Vsphere", Fog.providers[:vsphere]
      assert_equal "XenServer", Fog.providers[:xenserver]
    end
  end

  describe "#registered_providers" do
    it "includes existing providers" do
      assert_includes Fog.registered_providers, "Atmos"
      assert_includes Fog.registered_providers, "AWS"
      assert_includes Fog.registered_providers, "BareMetalCloud"
      assert_includes Fog.registered_providers, "Brightbox"
      assert_includes Fog.registered_providers, "Clodo"
      assert_includes Fog.registered_providers, "CloudSigma"
      assert_includes Fog.registered_providers, "Cloudstack"
      assert_includes Fog.registered_providers, "DigitalOcean"
      assert_includes Fog.registered_providers, "Dnsimple"
      assert_includes Fog.registered_providers, "DNSMadeEasy"
      assert_includes Fog.registered_providers, "Dreamhost"
      assert_includes Fog.registered_providers, "Dynect"
      assert_includes Fog.registered_providers, "Ecloud"
      assert_includes Fog.registered_providers, "Fogdocker"
      assert_includes Fog.registered_providers, "Glesys"
      assert_includes Fog.registered_providers, "GoGrid"
      assert_includes Fog.registered_providers, "Google"
      assert_includes Fog.registered_providers, "IBM"
      assert_includes Fog.registered_providers, "InternetArchive"
      assert_includes Fog.registered_providers, "Linode"
      assert_includes Fog.registered_providers, "Local"
      assert_includes Fog.registered_providers, "OpenNebula"
      assert_includes Fog.registered_providers, "OpenStack"
      assert_includes Fog.registered_providers, "Openvz"
      assert_includes Fog.registered_providers, "Ovirt"
      assert_includes Fog.registered_providers, "PowerDNS"
      assert_includes Fog.registered_providers, "ProfitBricks"
      assert_includes Fog.registered_providers, "Rackspace"
      assert_includes Fog.registered_providers, "Rage4"
      assert_includes Fog.registered_providers, "RiakCS"
      assert_includes Fog.registered_providers, "SakuraCloud"
      assert_includes Fog.registered_providers, "Serverlove"
      assert_includes Fog.registered_providers, "Softlayer"
      assert_includes Fog.registered_providers, "StormOnDemand"
      assert_includes Fog.registered_providers, "Vcloud"
      assert_includes Fog.registered_providers, "VcloudDirector"
      assert_includes Fog.registered_providers, "Vmfusion"
      assert_includes Fog.registered_providers, "Voxel"
      assert_includes Fog.registered_providers, "Vsphere"
      assert_includes Fog.registered_providers, "XenServer"
    end
  end

  describe "#available_providers" do
    it "includes existing providers" do
      assert_includes Fog.available_providers, "Atmos" if Atmos.available?
      assert_includes Fog.available_providers, "AWS" if AWS.available?
      assert_includes Fog.available_providers, "BareMetalCloud" if BareMetalCloud.available?
      assert_includes Fog.available_providers, "Brightbox" if Brightbox.available?
      assert_includes Fog.available_providers, "Clodo" if Clodo.available?
      assert_includes Fog.available_providers, "CloudSigma" if CloudSigma.available?
      assert_includes Fog.available_providers, "Cloudstack" if Cloudstack.available?
      assert_includes Fog.available_providers, "DigitalOcean" if DigitalOcean.available?
      assert_includes Fog.available_providers, "Dnsimple" if Dnsimple.available?
      assert_includes Fog.available_providers, "DNSMadeEasy" if DNSMadeEasy.available?
      assert_includes Fog.available_providers, "Dreamhost" if Dreamhost.available?
      assert_includes Fog.available_providers, "Dynect" if Dynect.available?
      assert_includes Fog.available_providers, "Ecloud" if Ecloud.available?
      assert_includes Fog.available_providers, "Fogdocker" if Fogdocker.available?
      assert_includes Fog.available_providers, "Glesys" if Glesys.available?
      assert_includes Fog.available_providers, "GoGrid" if GoGrid.available?
      assert_includes Fog.available_providers, "Google" if Google.available?
      assert_includes Fog.available_providers, "IBM" if IBM.available?
      assert_includes Fog.available_providers, "InternetArchive" if InternetArchive.available?
      assert_includes Fog.available_providers, "Linode" if Linode.available?
      assert_includes Fog.available_providers, "Local" if Local.available?
      assert_includes Fog.available_providers, "OpenNebula" if OpenNebula.available?
      assert_includes Fog.available_providers, "OpenStack" if OpenStack.available?
      assert_includes Fog.available_providers, "Openvz" if Openvz.available?
      assert_includes Fog.available_providers, "Ovirt" if Ovirt.available?
      assert_includes Fog.available_providers, "PowerDNS" if PowerDNS.available?
      assert_includes Fog.available_providers, "ProfitBricks" if ProfitBricks.available?
      assert_includes Fog.available_providers, "Rackspace" if Rackspace.available?
      assert_includes Fog.available_providers, "Rage4" if Rage4.available?
      assert_includes Fog.available_providers, "RiakCS" if RiakCS.available?
      assert_includes Fog.available_providers, "SakuraCloud" if SakuraCloud.available?
      assert_includes Fog.available_providers, "Serverlove" if Serverlove.available?
      assert_includes Fog.available_providers, "Softlayer" if Softlayer.available?
      assert_includes Fog.available_providers, "StormOnDemand" if StormOnDemand.available?
      assert_includes Fog.available_providers, "Vcloud" if Vcloud.available?
      assert_includes Fog.available_providers, "VcloudDirector" if VcloudDirector.available?
      assert_includes Fog.available_providers, "Vmfusion" if Vmfusion.available?
      assert_includes Fog.available_providers, "Voxel" if Voxel.available?
      assert_includes Fog.available_providers, "Vsphere" if Vsphere.available?
      assert_includes Fog.available_providers, "XenServer" if XenServer.available?
    end
  end

  describe "#services" do
    it "returns Hash of services" do
      assert_kind_of Hash, Fog.services
      assert_includes Fog.services, :cdn
      assert_includes Fog.services, :compute
      assert_includes Fog.services, :dns
      assert_includes Fog.services, :storage
    end
  end
end
