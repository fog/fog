require 'rubygems'
require 'base64'
require 'cgi'
require 'digest/md5'
require 'excon'
require 'formatador'
require 'hmac-sha1'
require 'hmac-sha2'
require 'json'
require 'mime/types'
require 'nokogiri'
require 'time'

__DIR__ = File.dirname(__FILE__)

$LOAD_PATH.unshift __DIR__ unless
  $LOAD_PATH.include?(__DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__DIR__))

require 'fog/collection'
require 'fog/connection'
require 'fog/model'
require 'fog/parser'
require 'fog/aws'
require 'fog/rackspace'
require 'fog/slicehost'
require 'fog/terremark'

module Fog

  module Mock
    DELAY = 1
  end

  class MockNotImplemented < StandardError; end

  def self.mock!
    @mocking = true
  end

  def self.mocking?
    !!@mocking
  end

end
