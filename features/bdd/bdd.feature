Feature: BDD of Fog

  As a Fog maintainer or contributor
  I want BDD
  So that I can spend time creating features, not killing bugs

  Scenario Outline: BDD w/ bundler
    Given the Fog project folder is the current folder
    And I want bundler
    And I intend to BDD with <testing_framework>
    When I describe Fog's behavior
    Then each BDD file requires its helper
    And the BDD helper requires '<lib>'
    And the BDD helper requires Bundler groups: '<lib_groups>'
  Examples:
    | testing_framework | lib_groups           | lib           |
    | rspec             | :bdd, :rspec         | bundler/setup |
#    | shindo           | :bdd, :shindo        | bundler/setup |


