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

        def self.availability_zone
          "us-east-1" << random_selection('abcd', 1)
        end

        def self.box_usage
          sprintf("%0.10f", rand / 100).to_f
        end

        def self.console_output
          'This is my console. There are many like it, but this one is mine. My console is my best friend. It is my life. I must master it as I master my life. My console, without me, is useless. Without my console, I am useless.'
        end

        def self.etag
          hex(32)
        end

        def self.image
          path = []
          (rand(3) + 2).times do
            path << letters(rand(9) + 8)
          end
          {
            "imageOwnerId"  => letters(rand(5) + 4),
            "productCodes"  => [],
            "kernelId"      => kernel_id,
            "ramdiskId"     => ramdisk_id,
            "imageState"    => "available",
            "imageId"       => image_id,
            "architecture"  => "i386",
            "isPublic"      => true,
            "imageLocation" => path.join('/'),
            "imageType"     => "machine"
          }
        end

        def self.image_id
          "ami-#{hex(8)}"
        end

        def self.key_fingerprint
          fingerprint = []
          20.times do
            fingerprint << hex(2)
          end
          fingerprint.join(':')
        end

        def self.image_id
          "ami-#{hex(8)}"
        end

        def self.instance_id
          "i-#{hex(8)}"
        end

        def self.ip_address
          ip = []
          4.times do
            ip << numbers(rand(3) + 1).to_i.to_s # remove leading 0
          end
          ip.join('.')
        end

        def self.kernel_id
          "aki-#{hex(8)}"
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

        def self.ramdisk_id
          "ari-#{hex(8)}"
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

        def self.reservation_id
          "r-#{hex(8)}"
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
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
            length
          )
        end

      end
    end

  end
end

Fog::AWS.reload