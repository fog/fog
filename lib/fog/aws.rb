require 'rubygems'
require 'base64'
require 'cgi'
require 'digest/md5'
require 'hmac-sha1'
require 'hmac-sha2'
require 'mime/types'

module Fog
  module AWS

    def self.reload
      current_directory = File.dirname(__FILE__)
      load "#{current_directory}/aws/ec2.rb"
      load "#{current_directory}/aws/simpledb.rb"
      load "#{current_directory}/aws/s3.rb"
    end

    if Fog.mocking?
      srand(Time.now.to_i)

      class Mock

        def self.etag
          hex(32)
        end

        def self.key_fingerprint
          fingerprint = []
          20.times do
            fingerprint << hex(2)
          end
          fingerprint.join(':')
        end

        def self.instance_id
        end

        def self.ip_address
          ip = []
          4.times do
            ip << numbers(rand(3) + 1).to_i.to_s # remove leading 0
          end
          ip.join('.')
        end

        def self.key_material
          key_material = ['-----BEGIN RSA PRIVATE KEY-----']
          20.times do
            key_material << base64(76)
          end
          key_material << base64(67) + '='
          key_material << '-----END RSA PRIVATE KEY-----'
          key_material.join("\n")
        end

        def self.owner_id
          numbers(12)
        end

        def self.request_id
          request_id = []
          request_id << hex(8)
          3.times do
            request_id << hex(4)
          end
          request_id << hex(12)
          request_id.join('-')
        end

        def self.snapshot_id
          "snap-#{hex(8)}"
        end

        def self.volume_id
          "vol-#{hex(8)}"
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

        def self.base64(length)
          random_selection(
            "ABCDEFGHIJKLMNOP QRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
            length
          )
        end

      end
    end

  end
end

Fog::AWS.reload