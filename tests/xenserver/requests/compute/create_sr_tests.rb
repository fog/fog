#
# @rubiojr
#
# Testing this requires a very specific setup:
#
# I use VirtualBox to virtualize XenServer/XCP and create the XenServer VM using
# two virtual disks under the same SATA controller. One of the virtual disks
# will be /dev/sdb, used to perform the tests.
#

Shindo.tests('Fog::Compute[:xenserver] | create_sr request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]
  
  tests('#create_sr "FOG TEST SR" with device /dev/sdb') do
    test('create an EXT SR') do
      ref = compute.create_sr compute.hosts.first.reference,
                             'FOG TEST SR',
                             'ext',
                             '',
                             { :device => '/dev/sdb' },
                             '0',
                             'user',
                             false,
                             {}
      valid_ref? ref
    end

    raises(Fog::XenServer::RequestFailed, 'raise when device in use') do
      ref = compute.create_sr compute.hosts.first.reference,
                             'FOG TEST SR',
                             'ext',
                             '',
                             { :device => '/dev/sdb' },
                             '0',
                             'user',
                             false,
                             {}
      valid_ref? ref
    end
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when arguments missing') { compute.create_sr }
  end

  # Clean-up
  compute.storage_repositories.each do |sr|
    next unless sr.name == 'FOG TEST SR'
    sr.pbds.each { |pbd| pbd.unplug }
    sr.destroy
  end

end
