# coding: utf-8
Shindo.tests('Fog::Compute[:sakuracloud] | list_ssh_keys request', ['sakuracloud', 'compute']) do

  @sshkey_format = {
    'Index'        => Integer,
    'ID'           => String,
    'Name'           => String,
    'PublicKey'    => String
  }

  tests('success') do

    tests('#list_ssh_keys') do
      sshkeys = compute_service.list_ssh_keys
      test 'returns a Hash' do
        sshkeys.body.is_a? Hash
      end
      if Fog.mock?
        tests('SSHKeys').formats(@sshkey_format, false) do
          sshkeys.body['SSHKeys'].first
        end
      else
        returns(200) { sshkeys.status }
        returns(false) { sshkeys.body.empty? }
      end
    end

  end

end
