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
