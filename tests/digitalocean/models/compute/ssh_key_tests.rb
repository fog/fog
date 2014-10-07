Shindo.tests("Fog::Compute[:digitalocean] | ssh_key model", ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]

  tests('The ssh_key model should') do

    test('#save') do
      @key = service.ssh_keys.create :name => 'fookey',
                                     :ssh_pub_key => 'fookey'
      @key.is_a? Fog::Compute::DigitalOcean::SshKey
    end

    tests('have the action') do
      test('reload') { @key.respond_to? 'reload' }
      %w{
        save
        destroy
      }.each do |action|
        test(action) { @key.respond_to? action }
      end
    end

    tests('have attributes') do
      attributes = [
        :id,
        :name,
        :ssh_pub_key
      ]

      tests("The key model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { @key.respond_to? attribute }
        end
      end
    end

    test('#destroy') do
      @key.destroy
    end

  end

end
