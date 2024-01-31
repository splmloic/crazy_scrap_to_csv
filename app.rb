require 'bundler'
Bundler.require
$:.unshift File.expand_path("./../lib", __FILE__)
require 'lib/app/scrapper.rb'

#require 'db/email.csv'
#require 'db/email.json'
#require 'views/fichier_2'

scrap = Scrapper.new

scrap.perform

