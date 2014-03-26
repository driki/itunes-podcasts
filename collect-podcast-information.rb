require 'csv'
require 'nokogiri'
require 'open-uri'

url = "https://itunes.apple.com/us/podcast/the-moth-podcast/id275699983?mt=2"
doc = Nokogiri::HTML(open(url))

description = doc.at_css('div.product-review p').text
img_src = doc.at_css('div.artwork img').attribute('src')

puts description
puts img_src