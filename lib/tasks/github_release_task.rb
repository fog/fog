require "rake"
require "rake/tasklib"
require 'octokit'
require 'netrc'

module Fog
  module Rake
    class GithubReleaseTask < ::Rake::TaskLib
      def initialize
        desc "Update the changelog since the last release"
        task(:github_release) do

          File.open('CHANGELOG.md', 'r') do |file|
            file.each_line do |line|
              @current_line = line
               if release_header?
                 create_release if !release_exists? && @release
                 @release_tag = release_match[1]
                 @release = line
               else
                 @release << line
               end
            end
          end
        end
      end

      private

      def create_release
        github.create_release "fog/fog", "v#{@release_tag}", {:name => "v#{@release_tag}", :body => @release}
        puts "creating release #{@release_tag}"
      end

      def releases
        return @releases if @releases
        response = github.releases("fog/fog")
        @releases = response.map {|r| r.tag_name }
      end

      def release_exists?
        releases.find {|r| r == "v#{@release_tag}" } != nil
      end

      def release_header?
        release_match != nil
      end

      def release_match
        @current_line.match (/## (\d+\.\d+\.\d+) \d+\/\d+\d+/)
      end

      def github
        unless @github
          Octokit.auto_paginate = true
          @github  = Octokit::Client.new :netrc => true
          unless @github.login
            @github = nil
            raise "Please create a ~/.netrc file to authenticate with github. For more information please see https://github.com/octokit/octokit.rb/blob/master/README.md#using-a-netrc-file"
          end
        end
        @github
      end
    end
  end
end
