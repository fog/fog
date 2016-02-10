require 'fog/vcloud_director/generators/compute/compose_vapp'

Shindo.tests("Compute::VcloudDirector - ComposeVapp", ['vclouddirector']) do

  @vapp_configuration = {
    :Description => 'a description',
    :InstantiationParams => {
      :DefaultStorageProfile => 'profile',
      :NetworkConfig => [
        {
          :networkName => 'net1',
          :networkHref => 'http://net1',
          :fenceMode => 'bridged'
        },
        {
          :networkName => 'net2',
          :networkHref => 'http://net2',
          :fenceMode => 'isolated'
        },
      ]
    },
    :source_templates => [
      { :href => 'http://template_1' },
      { :href => 'http://template_2' }
    ],
    :source_vms => [
      { :href => 'http://vm_1',
        :networks => [
          {
            :networkName => 'vm_net_1',
            :IsConnected => true,
            :IpAddressAllocationMode => 'POOL',
          },
          {
            :networkName => 'vm_net_2',
            :IsConnected => false,
            :IpAddressAllocationMode => 'DHCP'
          }
        ]
      },
      { :href => 'http://vm_2',
        :guest_customization => {
          :Enabled => true,
          :ComputerName => 'wally',
          :ChangeSid => false,
          :JoinDomainEnabled => false,
          :AdminPasswordEnabled => true,
          :AdminPasswordAuto => false,
          :AdminPassword => 'password',
          :ResetPasswordRequired => false,
          :CustomizationScript => 'ls -sal',
        },
        :StorageProfileHref => 'http://profile_1'
      }
    ]
  }

  tests('#check xml from generator').returns(true) do
    xml = Nokogiri.XML Fog::Generators::Compute::VcloudDirector::ComposeVapp.new(@vapp_configuration).generate_xml

    tags_with_values = {
      'ComposeVAppParams>Description' => 'a description',
      'ComposeVAppParams>AllEULAsAccepted' => 'true',
      'ComposeVAppParams>InstantiationParams>DefaultStorageProfileSection>StorageProfile' => 'profile',
      "ComposeVAppParams>InstantiationParams>NetworkConfigSection>NetworkConfig[networkName='net1']>Configuration>ParentNetwork[href='http://net1']~FenceMode" => 'bridged',
      "ComposeVAppParams>InstantiationParams>NetworkConfigSection>NetworkConfig[networkName='net2']>Configuration>ParentNetwork[href='http://net2']~FenceMode" => 'isolated',
      'ComposeVAppParams>SourcedItem>InstantiationParams>NetworkConnectionSection>PrimaryNetworkConnectionIndex' => '0',
      "ComposeVAppParams>SourcedItem>InstantiationParams>NetworkConnectionSection>NetworkConnection[network='vm_net_1']>NetworkConnectionIndex" => '0',
      "ComposeVAppParams>SourcedItem>InstantiationParams>NetworkConnectionSection>NetworkConnection[network='vm_net_1']>IsConnected" => 'true',
      "ComposeVAppParams>SourcedItem>InstantiationParams>NetworkConnectionSection>NetworkConnection[network='vm_net_1']>IpAddressAllocationMode" => 'POOL',
      "ComposeVAppParams>SourcedItem>InstantiationParams>NetworkConnectionSection>NetworkConnection[network='vm_net_2']>NetworkConnectionIndex" => '1',
      "ComposeVAppParams>SourcedItem>InstantiationParams>NetworkConnectionSection>NetworkConnection[network='vm_net_2']>IsConnected" => 'false',
      "ComposeVAppParams>SourcedItem>InstantiationParams>NetworkConnectionSection>NetworkConnection[network='vm_net_2']>IpAddressAllocationMode" => 'DHCP',
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_2']~InstantiationParams>GuestCustomizationSection>Enabled" => 'true',
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_2']~InstantiationParams>GuestCustomizationSection>ComputerName" => 'wally',
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_2']~InstantiationParams>GuestCustomizationSection>ChangeSid" => 'false',
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_2']~InstantiationParams>GuestCustomizationSection>JoinDomainEnabled" => 'false',
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_2']~InstantiationParams>GuestCustomizationSection>AdminPasswordEnabled" => 'true',
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_2']~InstantiationParams>GuestCustomizationSection>AdminPasswordAuto" => 'false',
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_2']~InstantiationParams>GuestCustomizationSection>AdminPassword" => 'password',
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_2']~InstantiationParams>GuestCustomizationSection>ResetPasswordRequired" => 'false',
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_2']~InstantiationParams>GuestCustomizationSection>CustomizationScript" => 'ls -sal',
    }

    empty_tags = [
      "ComposeVAppParams>SourcedItem>Source[href='http://template_1']",
      "ComposeVAppParams>SourcedItem>Source[href='http://template_2']",
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_1']",
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_2']",
      "ComposeVAppParams>SourcedItem>Source[href='http://vm_2']~StorageProfile[href='http://profile_1']",
    ]

    tags_with_values_match = tags_with_values.none? do |path|
      match = ((xml.css path[0]).inner_text == path[1])
      puts "\tExpected '#{path[1]}' on css path '#{path[0]}' but found '#{(xml.css path[0]).inner_text}'" unless match
      !match
    end

    tags_match = empty_tags.none? do |path|
      node = xml.css path
      puts "\tExpected to find '#{path}' but found '#{node}'." if node.empty?
      node.empty?
    end

    tags_with_values_match && tags_match
  end

end