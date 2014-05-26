module Fog
  module Parsers
    module Compute
      module VcloudDirector
        #
        #{:xmlns=>"http://www.vmware.com/vcloud/v1.5",
        # :xmlns_xsi=>"http://www.w3.org/2001/XMLSchema-instance",
        # :name=>"DevOps - Dev Network Connection",
        # :id=>"urn:vcloud:network:d5f47bbf-de27-4cf5-aaaa-56772f2ccd17",
        # :type=>"application/vnd.vmware.vcloud.orgNetwork+xml",
        # :href=>
        #  "https://example.com/api/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17",
        # :xsi_schemaLocation=>
        #  "http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd",
        # :Link=>
        #  [{:rel=>"up",
        #    :type=>"application/vnd.vmware.vcloud.org+xml",
        #    :name=>"DevOps",
        #    :href=>
        #     "https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a"},
        #   {:rel=>"down",
        #    :type=>"application/vnd.vmware.vcloud.metadata+xml",
        #    :href=>
        #     "https://example.com/api/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17/metadata"}],
        # :Description=>"",
        # :Configuration=>
        #  {:IpScope=>
        #    {:IsInherited=>"true",
        #     :Gateway=>"10.192.0.1",
        #     :Netmask=>"255.255.252.0",
        #     :Dns1=>"10.192.0.11",
        #     :Dns2=>"10.192.0.12",
        #     :DnsSuffix=>"dev.ad.mdsol.com",
        #     :IpRanges=>
        #      {:IpRange=>
        #        {:StartAddress=>"10.192.0.100", :EndAddress=>"10.192.3.254"}}},
        #   :FenceMode=>"bridged",
        #   :RetainNetInfoAcrossDeployments=>"false"}}
        #
        #<?xml version="1.0" encoding="UTF-8"?>
        #<OrgNetwork xmlns="http://www.vmware.com/vcloud/v1.5" name="DevOps - Dev Network Connection" id="urn:vcloud:network:d5f47bbf-de27-4cf5-aaaa-56772f2ccd17" type="application/vnd.vmware.vcloud.orgNetwork+xml" href="https://example.com/api/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
        #    <Link rel="up" type="application/vnd.vmware.vcloud.org+xml" name="DevOps" href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a"/>
        #    <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://example.com/api/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17/metadata"/>
        #    <Description/>
        #    <Configuration>
        #        <IpScope>
        #            <IsInherited>true</IsInherited>
        #            <Gateway>10.192.0.1</Gateway>
        #            <Netmask>255.255.252.0</Netmask>
        #            <Dns1>10.192.0.11</Dns1>
        #            <Dns2>10.192.0.12</Dns2>
        #            <DnsSuffix>dev.ad.mdsol.com</DnsSuffix>
        #            <IpRanges>
        #                <IpRange>
        #                    <StartAddress>10.192.0.100</StartAddress>
        #                    <EndAddress>10.192.3.254</EndAddress>
        #                </IpRange>
        #            </IpRanges>
        #        </IpScope>
        #        <FenceMode>bridged</FenceMode>
        #        <RetainNetInfoAcrossDeployments>false</RetainNetInfoAcrossDeployments>
        #    </Configuration>
        #</OrgNetwork>
        #
        class Network < VcloudDirectorParser
          def reset
            @response = { :ip_ranges => [] }
            @ip_range = {}
          end

          def start_element(name, attributes)
            super
            case name
            when 'OrgNetwork', 'OrgVdcNetwork' # OrgVdcNetwork belongs to 5.1
              network = extract_attributes(attributes)
              @response.merge!(network.reject {|key,value| ![:href, :name, :type].include?(key)})
              @response[:id] = @response[:href].split('/').last
            when 'Description',
              @response[:description] = value
            end
          end

          def end_element(name)
            case name
            when 'IsInherited'
              @response[:is_inherited] = (value == "true")
            when 'Gateway', 'Netmask', 'Dns1', 'Dns2'
              @response[name.downcase.to_sym] = value
            when 'DnsSuffix'
              @response[:dns_suffix] = value
            when 'StartAddress'
              @ip_range[:start_address] = value
            when 'EndAddress'
              @ip_range[:end_address] = value
            when 'IpRange'
              @response[:ip_ranges] << @ip_range
              @ip_range = {}
            end
          end
        end
      end
    end
  end
end
