require 'vcloud/spec_helper'

if Fog.mocking?
  describe Fog::Vcloud, :type => :mock_vcloud_request do
    subject { @vcloud }

    it_should_behave_like "all login requests"
  end
else
end
