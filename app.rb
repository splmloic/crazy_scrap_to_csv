require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib/app/", __FILE__)
require 'scrapper.rb'

scrap = Scrapper.new

scrap.perform
