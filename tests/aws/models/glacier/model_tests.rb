Shindo.tests('AWS::Glacier | models', ['aws', 'glacier']) do

  tests('success') do
    tests('vaults') do
      tests('getting a missing vault') do
        returns(nil) { Fog::AWS[:glacier].vaults.get('no-such-vault') }
      end

      vault = nil
      tests('creating a vault') do
        vault = Fog::AWS[:glacier].vaults.create :id => 'Fog-Test-Vault'
        tests("id is Fog-Test-Vault").returns('Fog-Test-Vault') {vault.id}
      end

      tests('all') do
        tests('contains vault').returns(true) { Fog::AWS[:glacier].vaults.collect {|vault| vault.id}.include?(vault.id)}
      end

      tests('destroy') do
        vault.destroy
        tests('removes vault').returns(nil) {Fog::AWS[:glacier].vaults.get(vault.id)}
      end
    end
  end
end