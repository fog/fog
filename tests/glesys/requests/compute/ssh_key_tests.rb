Shindo.tests("Fog::Compute[:glesys] | ssh_key requests", ["glesys", "compute"]) do
  @testdescription = "My test key to be removed"
  @testdata = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDv+r/dCIDv+YazWsyc1WCixR+iOeaswTx1U45h6vh4/ fog-unittest@GleSYS"
  @testdata_malformed = "ssh-rot13 AAAAthis_is_not_an_ssh_key fog-unittest@GleSYS"

  tests("success") do
    tests("#ssh_key_add").formats(Glesys::Compute::Formats::SshKeys::ADD) do
      pending if Fog.mocking?
      @resp = Fog::Compute[:glesys].ssh_key_add(:description => @testdescription, :sshkey => @testdata)
      @resp.body["response"]
    end

    unless Fog.mocking?
      Fog::Compute[:glesys].ssh_keys.destroy(@resp.body["response"]["sshkey"]["id"])
      @key = Fog::Compute[:glesys].ssh_keys.create(:description => @testdescription, :data => @testdata)
    end

    tests("#ssh_key_list").formats(Glesys::Compute::Formats::SshKeys::LIST) do
      pending if Fog.mocking?
      @resp = Fog::Compute[:glesys].ssh_key_list
      @resp.body["response"]
    end

    unless Fog.mocking?
      Fog::Compute[:glesys].ssh_keys.destroy(@key.id)
      @key = Fog::Compute[:glesys].ssh_keys.create(:description => @testdescription, :data => @testdata)
    end

    tests("#ssh_key_remove").formats(Glesys::Compute::Formats::SshKeys::REMOVE) do
      pending if Fog.mocking?
      @resp = Fog::Compute[:glesys].ssh_key_remove(:sshkeyids => @key.id)
      @resp.body["response"]
    end
  end

  tests("failure") do
    tests("#ssh_key_add with malformed key data").raises(Excon::Errors::HTTPStatusError) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].ssh_key_add(:description => @testdescription, :data => @testdata_malformed)
    end

    tests("#ssh_key_remove with nonexistent/invalid key id").raises(Excon::Errors::HTTPStatusError) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].ssh_key_remove(:id => -1)
    end
  end
end
