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

module Fog

  class MockNotImplemented < StandardError; end

  def self.mock!
    @mocking = true
    self.reload
  end

  def self.mocking?
    !!@mocking
  end

  def self.dependencies
    [
      'fog/collection.rb',
      'fog/connection.rb',
      'fog/model.rb',
      'fog/parser.rb',
      'fog/aws.rb',
      'fog/rackspace.rb',
      'fog/slicehost.rb',
      'fog/terremark.rb'
      ]
  end

  def self.reload
    self.dependencies.each {|dependency| load(dependency)}
  end

end

Fog.dependencies.each {|dependency| require(dependency)}
