require 'rubygems'
require 'rubygems'
require 'base64'
require 'cgi'
require 'digest/md5'
require 'hmac-sha1'
require 'hmac-sha2'
require 'json'
require 'mime/types'

__DIR__ = File.dirname(__FILE__)

$LOAD_PATH.unshift __DIR__ unless
  $LOAD_PATH.include?(__DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__DIR__))

module Fog

  def self.mock!
    @mocking = true
    self.reload
  end

  def self.mocking?
    !!@mocking
  end

  def self.reload
    load "fog/aws.rb"
    load "fog/rackspace.rb"
  end

end

Fog.reload
