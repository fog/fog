require 'rubygems'
require 'base64'
require 'cgi'
require 'digest/md5'
require 'excon'
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

  def self.mock!
    @mocking = true
    self.reload
  end

  def self.mocking?
    !!@mocking
  end

  def self.reload
    load "fog/collection.rb"
    load "fog/connection.rb"
    load "fog/model.rb"
    load "fog/parser.rb"

    load "fog/aws.rb"
    load "fog/rackspace.rb"
    load "fog/slicehost.rb"
  end

  def self.credential=(new_credential)
    @credential = new_credential
    @credentials = nil
  end

  def self.credential
    @credential || :default
  end

  def self.credentials
    @credentials ||= begin
      path = File.expand_path('~/.fog')
      credentials = if File.exists?(path)
        File.open(path) do |file|
          YAML.load(file.read)
        end
      else
        nil
      end
      unless credentials && credentials[credential]
        print("\n  To run as '#{credential}', add credentials like the following to ~/.fog\n")
        yml = <<-YML

:#{credential}:
  :aws_access_key_id:     INTENTIONALLY_LEFT_BLANK
  :aws_secret_access_key: INTENTIONALLY_LEFT_BLANK
  :rackspace_api_key:     INTENTIONALLY_LEFT_BLANK
  :rackspace_username:    INTENTIONALLY_LEFT_BLANK
  :slicehost_password:    INTENTIONALLY_LEFT_BLANK

YML
        print(yml)
        raise(ArgumentError.new("Missing Credentials"))
      end
      credentials[credential]
    end
  end

end

Fog.reload
