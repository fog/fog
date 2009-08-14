require 'rubygems'
require 'base64'
require 'cgi'
require 'digest/md5'
require 'hmac-sha1'
require 'hmac-sha2'
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
      Fog::AWS::EC2.reload
      load "#{current_directory}/aws/simpledb.rb"
      Fog::AWS::SimpleDB.reload
      load "#{current_directory}/aws/s3.rb"
      Fog::AWS::S3.reload
    end

    if Fog.mocking?
      srand(Time.now.to_i)

      class Mock

        def self.letters(length)
          random_selection(
            'abcdefghijklmnopqrstuvwxyz',
            length
          )
        end

        def self.numbers(length)
          random_selection(
            '0123456789',
            length
          )
        end

        def self.hex(length)
          random_selection(
            '0123456789abcdef',
            length
          )
        end

        def self.etag
          hex(32)
        end

        private

        def self.random_selection(characters, length)
          selection = ''
          length.times do
            position = rand(characters.length)
            selection << characters[position..position]
          end
          selection
        end

      end
    end

  end
end
