@vcs
Feature: Fog has various rake tasks to aide development

  In order to release frequently
  As a Fog developer
  I want rake tasks to perform the routine build task

  Background:
    Given the Fog project folder is the current folder
    And I configured git sanely
    And the repository status is clean

  Scenario: Build a gem
    Given "pkg" folder is deleted
      And the following directories should not exist:
      | ./../../pkg/ |
    When I run "rake build"
    Then the following directories should exist:
       | ./../../pkg/ |
      And the exit status should be 0
      And the output should match:
      """
      fog (.*) built to pkg/fog-(.*)\.gem
      """

  Scenario Outline: Generate Fog runtime RubyGem
    Given the following directories should exist:
      | ./../../pkg/ |
    When file "./pkg/fog-*.gem" is created    #
    Then gem spec key "<spec-key>" contains /<regex>/

  Examples:
    | spec-key           | regex                                              |
    | rdoc_options       | --charset=UTF-8                                    |
    | dependencies       | runtime name=\"bundler\" requirements=\"~> 1.0.4\" |
    | rubyforge_project  | fog                                                |
    | rubygems_version   | 1\.3\.7                                            |
    | homepage           | http://github.com/geemus/fog                       |
    | require_paths      | \"lib,\", \"ext\"                                           |
    | default_executable | fog                                                |
    | extensions         | ext/geminstall_hook/extconf.rb                     |











