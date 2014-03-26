require 'csv'
require 'nokogiri'
require 'open-uri'
require 'json'

CSV.open("itunes-podcast-details.csv", "w") do |podcast_details|

  csv_text = File.read('itunes-podcast-list.csv')
  csv = CSV.parse(csv_text)
  
  csv.each do |row|

    url = row[0]
    title = row[1]

    id = url.scan(/id[0-9]+/)[0].scan(/[0-9]+/)[0]
    puts "ID: #{id}"
    # You can much of this structured here: https://itunes.apple.com/lookup?id=275699983
    podcast_data = JSON.parse(open("https://itunes.apple.com/lookup?id=#{id}") { |io| data = io.read })

    doc = Nokogiri::HTML(open(url))

    if doc.at_css('div.product-review p')
        description = doc.at_css('div.product-review p').text
    end

    if doc.at_css('div.artwork img')       
        img_src = doc.at_css('div.artwork img').attribute('src')
    end
    
    if doc.at_css('li.genre a')
        category = doc.at_css('li.genre a').text
    end
    
    if doc.at_css('li.language')
        language = doc.at_css('li.language').text
    end

    if doc.at_css('div.rating')
        rating_score = doc.at_css('div.rating').attribute('aria-label').text
    end

    if doc.at_css('span.rating-count')
        rating_count = doc.at_css('span.rating-count').text
    end
    
    if doc.at_css('div.extra-list ul.list li a')
        website = doc.at_css('div.extra-list ul.list li a').attribute('href')
    end
    
    if doc.css('div.customer-reviews')
        customer_reviews = doc.css('div.customer-reviews')
    end

    text_from_reviews = []
    customer_reviews.each do |review|
    	review_text = review.css('p.content').text.strip
    	text_from_reviews << review_text
    end

    podcast_details << [url, 
                        title, 
                        img_src, 
                        category, 
                        language, 
                        rating_score, 
                        rating_count, 
                        website, 
                        text_from_reviews, 
                        podcast_data]
  end
end