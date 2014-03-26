require 'csv'
require 'nokogiri'
require 'open-uri'

url = "https://itunes.apple.com/us/podcast/the-moth-podcast/id275699983?mt=2"
doc = Nokogiri::HTML(open(url))

description = doc.at_css('div.product-review p').text
img_src = doc.at_css('div.artwork img').attribute('src')
category = doc.at_css('li.genre a').text
language = doc.at_css('li.language').text
rating_score = doc.at_css('div.rating').attribute('aria-label').text
rating_count = doc.at_css('span.rating-count').text
website = doc.at_css('div.extra-list ul.list li a').attribute('href')
customer_reviews = doc.css('div.customer-reviews')

text_from_reviews = []
customer_reviews.each do |review|
	review_text = review.css('p.content').text.strip
	text_from_reviews << review_text
end

puts description
puts img_src
puts category
puts language
puts rating_score
puts rating_count
puts website
puts text_from_reviews