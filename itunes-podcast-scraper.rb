require 'csv'
require 'nokogiri'
require 'open-uri'

# Bulk download scraper for iTunes Podcasts

CATEGORIES =  {
                :arts => "https://itunes.apple.com/us/genre/podcasts-arts/id1301?mt=2",
                :business => "https://itunes.apple.com/us/genre/podcasts-business/id1321?mt=2",
                :comedy => "https://itunes.apple.com/us/genre/podcasts-comedy/id1303?mt=2",
                :education => "https://itunes.apple.com/us/genre/podcasts-education/id1304?mt=2",
                :games_and_hobbies => "https://itunes.apple.com/us/genre/podcasts-games-hobbies/id1323?mt=2",
                :government_and_organizations => "https://itunes.apple.com/us/genre/podcasts-government-organizations/id1325?mt=2",
                :health => "https://itunes.apple.com/us/genre/podcasts-health/id1307?mt=2",                
                :kids_and_family => "https://itunes.apple.com/us/genre/podcasts-kids-family/id1305?mt=2",
                :music => "https://itunes.apple.com/us/genre/podcasts-music/id1310?mt=2",
                :news_and_politics => "https://itunes.apple.com/us/genre/podcasts-news-politics/id1311?mt=2",
                :religion_and_spirituality => "https://itunes.apple.com/us/genre/podcasts-religion-spirituality/id1314?mt=2",
                :science_and_medicine => "https://itunes.apple.com/us/genre/podcasts-science-medicine/id1315?mt=2",
                :society_and_culture => "https://itunes.apple.com/us/genre/podcasts-society-culture/id1324?mt=2",
                :sports_and_recreation => "https://itunes.apple.com/us/genre/podcasts-sports-recreation/id1316?mt=2",
                :tv_and_film => "https://itunes.apple.com/us/genre/podcasts-tv-film/id1309?mt=2",
                :technology => "https://itunes.apple.com/us/genre/podcasts-technology/id1318?mt=2"
              }

ALPHABET = ('A'..'Z').to_a + ["*"]

CSV.open(" itunes-podcast-category-lists.csv", "w") do |csv|

  CATEGORIES.each do |k,v|

    ALPHABET.each do |letter|
      alpha_podcast_url = "#{v}&letter=#{letter}"

      # Determine how many pages there are.
      list_of_podcasts_doc = Nokogiri::HTML(open(alpha_podcast_url))
      number_of_pages = list_of_podcasts_doc.xpath("//ul[2]/li/a").size - 1 # Next is in the list, discount it
      
      (1 .. number_of_pages).each do |i|
        url = alpha_podcast_url+"&page=#{i}"
        puts "#{k}, #{url}"
        csv << [k, url]        
      end      
    end
  end

end # CSV writing