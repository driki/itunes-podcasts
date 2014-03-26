require 'csv'
require 'nokogiri'
require 'open-uri'

# Collect iTunes URLs for each of their podcasts

CSV.open("itunes-podcast-list.csv", "w") do |podcast_list|

  csv_text = File.read('itunes-podcast-category-lists.csv')
  csv = CSV.parse(csv_text)
  csv.each do |row|
    url = row[1]
    doc = Nokogiri::HTML(open(url))
    
    podcasts = doc.xpath('//div[2]/div[1]/ul/li/a')
    
    podcasts.each do |podcast|
      podcast_url = podcast["href"]
      podcast_name = podcast.text
      puts "#{podcast_url} :: #{podcast_name}"

      podcast_list << [podcast_url, podcast_name]
    end
  end

end