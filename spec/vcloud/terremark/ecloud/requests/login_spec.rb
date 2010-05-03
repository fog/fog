require 'spec_helper'

describe Fog::Vcloud, :type => :tmrk_ecloud_request do
  subject { @vcloud }

  it_should_behave_like "all login requests"
end
