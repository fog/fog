Shindo.tests('Fog::Compute[:cloudstack] | ssh key pairs requests', ['cloudstack']) do

  @ssh_keys_format = {
    'listsshkeypairsresponse'  => {
      'count' => Integer,
      'sshkeypair' => [
        'fingerprint' => String,
        'name' => String,
        'privatekey' => Fog::Nullable::String
      ]
    }
  }

  tests('success') do

    tests('#list_ssh_key_pairs').formats(@ssh_keys_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].list_ssh_key_pairs
    end

  end

end
