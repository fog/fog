#
# @rubiojr
#
# Testing this requires a very specific setup:
#
# I use VirtualBox to virtualize XenServer/XCP and create the XenServer VM using
# two virtual disks under the same SATA controller. One of the virtual disks
# will be /dev/sdb, used to perform the tests.
#

Shindo.tests('Fog::Compute[:xenserver] | destroy_sr request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]
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

  tests('#destroy_sr') do
    test('destroyed "FOG TEST SR"') do
      compute.storage_repositories.each do |sr|
        next unless sr.name == 'FOG TEST SR'
        sr.pbds.each { |pbd| pbd.unplug }
      end
      compute.destroy_sr ref
      (compute.storage_repositories.find { |sr| sr.name == 'FOG TEST SR' }).nil?
    end

    raises(Fog::XenServer::RequestFailed,
           'raises HandleInvalid trying to destroy it twice') do
      compute.destroy_sr ref
    end
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when arguments missing') \
      { compute.destroy_sr }
  end

end
