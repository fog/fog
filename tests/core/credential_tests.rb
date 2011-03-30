Shindo.tests do
  before do
    @old_home = ENV['HOME']
    @old_rc   = ENV['FOG_RC']
    Fog.instance_variable_set('@credential_path', nil) # kill memoization
  end

  after do
    ENV['HOME'] = @old_home
    ENV['FOG_RC'] = @ld_rc
  end

  tests('credentials_path') do
    returns('/rc/path', 'FOG_RC takes precedence over HOME') {
      ENV['HOME'] = '/home/path'
      ENV['FOG_RC'] = '/rc/path'
    }

    returns('/expanded/path', 'properly expands paths') {
      ENV['FOG_RC'] = '/expanded/subdirectory/../path'
      Fog.credentials_path
    }

    returns('/home/me/.fog', 'falls back to home path if FOG_RC not set') {
      ENV['HOME'] = '/home/me'
      ENV.delete('FOG_RC')
      Fog.credentials_path
    }

    returns(nil, 'returns nil when neither FOG_RC or HOME are set') {
      ENV.delete('HOME')
      ENV.delete('FOG_RC')
      Fog.credentials_path
    }
  end
end
