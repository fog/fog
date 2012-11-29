# -*- encoding: utf-8 -*-

require 'tmpdir'

def nuke_memoization
  Fog.instance_variable_set('@credential_path', nil) # kill memoization
  Fog.instance_variable_set('@credential', nil) # kill memoization
end

def reset_credential_state
  ENV.delete('HOME')
  ENV.delete('FOG_RC')
  ENV.delete('FOG_CREDENTIAL')
  nuke_memoization
end

def setup_path(opts={})
  # on macos, Dir.mktmpdir will return a path under /var, which is
  # actually a symlink to /private/var. without the realpath below,
  # these tests will fail due to Pathname.pwd (and thus
  # Fog.find_credentials) returning a path under /private/var.
  dir = Pathname.new(Dir.mktmpdir('fog')).realpath
  (@trash ||= []) << dir
  ENV['HOME'] = dir.to_s if opts[:HOME]

  if opts[:create_rc] or opts[:FOG_RC]
    rcfile = dir.join('.fog')
    rcfile.open('w') {|f| f.close}
    ENV['FOG_RC'] = rcfile.to_s if opts[:FOG_RC]
  end

  dir
end

def with_credential_safety
  orig_home = ENV['HOME']
  orig_fog_rc = ENV['FOG_RC']
  orig_fog_credential = ENV['FOG_CREDENTIAL']
  orig_credentials = Fog.credentials

  reset_credential_state

  yield
ensure
  ENV['HOME'] = orig_home if orig_home
  ENV['FOG_RC'] = orig_fog_rc if orig_fog_rc
  ENV['FOG_CREDENTIAL'] = orig_fog_credential if orig_fog_credential
  Fog.credentials = orig_credentials if orig_credentials
end

def with_tmpdir_cleanup
  @trash ||= []
  yield
ensure
  @trash.delete_if do |path|
    begin
      path.rmtree
      true
    rescue Errno::ENOENT
      true
    rescue SystemCallError
      false
    end
  end
  remove_instance_variable :@trash
end

def within_tmpdir(&block)
  dir = Pathname.new(Dir.mktmpdir('fog')).realpath
  (@trash ||= []) << dir
  Dir.chdir(dir, &block)
end


with_credential_safety do
  with_tmpdir_cleanup do
    within_tmpdir do

      Shindo.tests do
        before { reset_credential_state }

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
          tests('with parent directory checking') do
            before do
              @dir = setup_path :create_rc => true
            end

            returns('.fog', 'finds .fog in current directory') do
              Dir.chdir(@dir) do
                rcfile = Pathname.new(Fog.find_credentials)
                rcfile.relative_path_from(@dir).to_s
              end
            end

            returns('../.fog', 'finds .fog in parent directory') do
              dir = @dir.join('one')
              dir.mkpath
              Dir.chdir(dir) do
                rcfile = Pathname.new(Fog.find_credentials)
                rcfile.relative_path_from(dir).to_s
              end
            end

            returns('../../.fog', 'finds .fog in parent of parent directory') do
              dir = @dir.join('one').join('two')
              dir.mkpath
              Dir.chdir(dir) do
                rcfile = Pathname.new(Fog.find_credentials)
                rcfile.relative_path_from(dir).to_s
              end
            end
          end

          test('FOG_RC takes precedence over HOME') do
            setup_path :create_rc => true, :HOME => true
            setup_path :create_rc => true, :FOG_RC => true
            Fog.credentials_path == ENV['FOG_RC']
          end

          test('properly expands paths') do
            dir = setup_path
            unexpanded = dir.join('expanded/subdirectory/../path/.fog')
            ENV['FOG_RC'] = unexpanded.to_s
            expanded = dir.join('expanded/path/.fog')
            expanded.parent.mkpath
            expanded.open('w') {|f| f.close}
            Fog.credentials_path == expanded.to_s
          end

          test('falls back to home path if FOG_RC is not set') do
            setup_path :create_rc => true, :HOME => true
            Fog.credentials_path == File.join(ENV['HOME'], '.fog')
          end

          returns(nil, 'ignores home path if it does not exist') do
            ENV['HOME'] = '/no/such/path'
            Fog.credentials_path
          end

          returns(nil, 'returns nil when neither FOG_RC nor HOME are set') do
            Fog.credentials_path
          end
        end

      end # Shindo.tests

    end # within_tmpdir
  end # with_tmpdir_cleanup
end # with_credential_safety

