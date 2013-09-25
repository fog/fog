#
# @rubiojr
#
# Testing this requires a very specific setup:
#
# I use VirtualBox to virtualize XenServer/XCP and create the XenServer VM using
# two virtual disks under the same SATA controller. One of the virtual disks
# will be /dev/sdb, used to perform the tests.
#

Shindo.tests('Fog::Compute[:xenserver] | unplug_pbd request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]
  # Creating a new SR automatically plugs the PBD
  # We need the SR available for this to work, so create it first
  ref = compute.create_sr compute.hosts.first.reference,
                         'FOG TEST SR',
                         'ext',
                         '',
                         { :device => '/dev/sdb' },
                         '0',
                         'user',
                         false,
                         {}
  
  tests('#unplug_pbd') do
    test('unplugged') do
      sr = compute.storage_repositories.find { |sr| sr.name == 'FOG TEST SR' }
      pbd = sr.pbds.first
      compute.unplug_pbd pbd.reference
      pbd.reload
      pbd.currently_attached == false
    end
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when arguments missing') \
      { compute.unplug_pbd }
  end
  
  # Clean-up
  compute.storage_repositories.each do |sr|
    next unless sr.name == 'FOG TEST SR'
    sr.pbds.each { |pbd| pbd.unplug }
    sr.destroy
  end

end
