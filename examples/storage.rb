require 'rubygems'
require 'shindo'

require File.join(File.dirname(__FILE__), '..', 'lib', 'fog')
require File.join(File.dirname(__FILE__), '..', 'tests', 'helper')

Shindo.tests('storage tests', 'storage') do

  # iterate over all the providers
  Fog.providers.each do |provider|

    # return immediately if provider does not have storage
    break unless provider.services.include?(:storage)

    tests(provider, provider.to_s.downcase) do

      # use shortcuts to instantiate connection
      @storage = Fog::Storage.new(:provider => provider.to_s)

      # for compatibility public is simply true or false
      [false, true].each do |publicity|

        tests(":public => #{publicity}") do

          # create a directory
          #   key should be a unique string
          #   public should be a boolean
          tests('@directory = @directories.create').succeeds do
            @directory = @storage.directories.create(
              :key    => "fogstoragedirectory#{Time.now.to_i}",
              :public => publicity
            )
          end

          # create a file in the directory
          #   key can be any string
          #   body can be a string or a file as File.open(path)
          #   public should be a boolean and match the directory
          tests('@file = @directory.files.create').succeeds do
            @file = @directory.files.create(
              :body   => 'fog_storage_object_body',
              :key    => 'fogstorageobject',
              :public => publicity
            )
          end

          # list files
          tests('@files = @directory.files').succeeds do
            @files = @directory.files
          end

          # fetch the latest files data
          tests('@files.reload').succeeds do
            @files.reload
          end

          # get a file
          tests('@directory.files.get(@file.key)').succeeds do
            @directory.files.get(@file.key)
          end

          # fetch the latest file data
          tests('@file.reload').succeeds do
            @file.reload
          end

          # test the publicity of files
          # Local is unable to inherently serve files, so we can skip it
          unless provider == Local
            # if the file is public it should have a url
            test('!!@file.public_url == publicity') do
              pending if Fog.mocking?
              !!@file.public_url == publicity
            end

            # if it is public ensure that public url is usable
            if publicity
              tests('Excon.get(@file.public_url).body').returns('fog_storage_object_body') do
                pending if Fog.mocking?
                Excon.get(@file.public_url).body
              end
            end
          end

          # destroy the file
          tests('@file.destroy').succeeds do
            @file.destroy
          end

          # destroy the directory
          tests('@directory.destroy').succeeds do
            @directory.destroy
          end

        end

      end

    end

  end

end
