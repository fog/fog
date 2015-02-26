require 'google/api_client'

Shindo.tests('Google | credentials', ['google']) do

  tests('success') do
    pending if Fog.mocking?

    google_key_location = Fog.credentials[:google_key_location]
    if google_key_location.nil?
      tests('Needs a :google_key_location credentials key').pending
    end
    google_key_string = File.open(File.expand_path(google_key_location), 'rb') { |io| io.read }

    tests("#using_p12_key_file").succeeds do
      Fog::Compute::Google.new(:google_key_location => google_key_location,
                               :google_key_string => nil,
                               :google_json_key_location => nil,
                               :google_json_key_string => nil)
    end

    tests("#using_p12_key_string").succeeds do
      Fog::Compute::Google.new(:google_key_location => nil,
                               :google_key_string => google_key_string,
                               :google_json_key_location => nil,
                               :google_json_key_string => nil)
    end
  end

  tests('success') do
    pending if Fog.mocking?

    google_json_key_location = Fog.credentials[:google_json_key_location]
    if google_json_key_location.nil?
      tests('Needs a :google_json_key_location credentials key').pending
    end
    google_json_key_string = File.open(File.expand_path(google_json_key_location), 'rb') { |io| io.read }

    tests("#using_json_key_file").succeeds do
      Fog::Compute::Google.new(:google_key_location => nil,
                               :google_key_string => nil,
                               :google_json_key_location => google_json_key_location,
                               :google_json_key_string => nil)
    end

    tests("#using_json_key_string").succeeds do
      Fog::Compute::Google.new(:google_key_location => nil,
                               :google_key_string => nil,
                               :google_json_key_location => nil,
                               :google_json_key_string => google_json_key_string)
    end
  end

  tests('failure') do
    tests("#missing_google_project").raises(ArgumentError, 'raises ArgumentError when google_project is missing') do
       Fog::Compute::Google.new(:google_project => nil)
    end

    tests("#missing_google_client_email").raises(ArgumentError, 'raises ArgumentError when google_client_email is missing') do
      pending if Fog.mocking? # Mock doesn't check google_client_email
      Fog::Compute::Google.new(:google_client_email => nil,
                               :google_json_key_location => nil) # JSON key overrides google_client_email
    end

    tests("#missing_keys").raises(ArgumentError, 'raises ArgumentError when google keys are missing') do
      pending if Fog.mocking? # Mock doesn't check missing keys
      Fog::Compute::Google.new(:google_key_location => nil,
                               :google_key_string => nil,
                               :google_json_key_location => nil,
                               :google_json_key_string => nil)
    end
  end

end
