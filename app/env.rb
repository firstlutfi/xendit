require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'site_prism/table'
require 'byebug'
require 'dotenv'
require 'yaml'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/core_ext/hash/indifferent_access'
require 'rspec/expectations'
require 'data_magic'
require_relative 'helpers/base_helper'

include BaseHelper
include DataMagic

DataMagic.yml_directory = "#{Dir.pwd}/app/data"
Dotenv.load
Capybara.default_driver = :selenium_chrome
Capybara.app_host = ENV['BASE_URL']
@report_path = File.absolute_path('./report')
Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.prune_strategy = { keep: 50 }
Capybara::Screenshot.append_timestamp = true
Capybara::Screenshot.webkit_options = {
  width: 1366,
  height: 768
}
Capybara.save_path = "#{@report_path}/screenshots"
puts ' ========Deleting old reports and logs========='
FileUtils.rm_rf(Dir.glob("#{@report_path}/*"))
FileUtils.mkdir_p @report_path
Faker::Config.locale = 'id'
