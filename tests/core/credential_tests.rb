Shindo.tests do
  before do
    @old_home = ENV['HOME']
    @old_rc   = ENV['FOG_RC']
    @old_credential = ENV['FOG_CREDENTIAL']
    @old_credentials = Fog.credentials
    Fog.instance_variable_set('@credential_path', nil) # kill memoization
    Fog.instance_variable_set('@credential', nil) # kill memoization
  end

  after do
    ENV['HOME'] = @old_home
    ENV['FOG_RC'] = @old_rc
    ENV['FOG_CREDENTIAL'] = @old_credential
    Fog.credentials = @old_credentials
  end

  tests('credential') do
    returns(:default, "is :default") { Fog.credential }

    returns(:foo, "can be set directly") do
      Fog.credential = "foo"
      Fog.credential
    end

    returns(:bar, "can be set with environment variable") do
      ENV["FOG_CREDENTIAL"] = "bar"
      Fog.credential
    end
  end

  tests('credentials_path') do
    returns('/rc/path', 'FOG_RC takes precedence over HOME') do
      ENV['HOME'] = '/home/path'
      ENV['FOG_RC'] = '/rc/path'
    end

    returns('/expanded/path', 'properly expands paths') do
      ENV['FOG_RC'] = '/expanded/subdirectory/../path'
      Fog.credentials_path
    end

    returns(File.join(ENV['HOME'], '.fog'), 'falls back to home path if FOG_RC not set') do
      ENV.delete('FOG_RC')
      Fog.credentials_path
    end

    returns(nil, 'ignores home path if it does not exist') do
      ENV.delete('FOG_RC')
      ENV['HOME'] = '/no/such/path'
      Fog.credentials_path
    end

    returns(nil, 'File.expand_path raises because of non-absolute path') do
      ENV.delete('FOG_RC')
      ENV['HOME'] = '.'

      if RUBY_PLATFORM == 'java'
        Fog::Logger.warning("Stubbing out non-absolute path credentials test due to JRuby bug: https://github.com/jruby/jruby/issues/1163")
        nil
      else
        Fog.credentials_path
      end
    end

    returns(nil, 'returns nil when neither FOG_RC or HOME are set') do
      ENV.delete('HOME')
      ENV.delete('FOG_RC')
      Fog.credentials_path
    end
  end

  tests('symbolize_credential?') do
    returns(true, "username") { Fog.symbolize_credential?(:username) }
    returns(false, "headers") { Fog.symbolize_credential?(:headers) }
  end

  tests('symbolize_credentials') do
    h = {
      "a" => 3,
      :something => 2,
      "connection_options" => {"val" => 5},
      :headers => { 'User-Agent' => "my user agent" }
      }

    returns(
              :a => 3,
      :something => 2,
      :connection_options => {:val => 5},
      :headers => { 'User-Agent' => "my user agent" }
      ) { Fog.symbolize_credentials h }
  end
end
