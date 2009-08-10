require 'rubygems'
require 'base64'
require 'cgi'
require 'digest/md5'
require 'hmac-sha1'
require 'mime/types'

current_directory = File.dirname(__FILE__)
require "#{current_directory}/aws/ec2"
require "#{current_directory}/aws/simpledb"
require "#{current_directory}/aws/s3"

module Fog
  module AWS

    def self.reload
      current_directory = File.dirname(__FILE__)
      load "#{current_directory}/aws/ec2.rb"
      load "#{current_directory}/aws/simpledb.rb"
      load "#{current_directory}/aws/s3.rb"
      Fog::AWS::S3.reload
    end

  end
end
