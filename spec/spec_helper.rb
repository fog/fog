require 'spec'
require 'open-uri'
require 'fog'
require 'fog/bin'

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end
