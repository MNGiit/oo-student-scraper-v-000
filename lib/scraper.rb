require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    #array_hashes student => student_info
    # {:name => "Abby Smith", :location}
    students = []

    html = File.read('./fixtures/student-site/index.html')    
    doc = Nokogiri::HTML(html)
    
    #item = doc.css("roster-cards-container") #doesn't work
    items = doc.css("div.roster-cards-container")
    
    cards = items.css("div.student-card")
    #cards = items.css(".student-card")
    
    #student_name = cards[0].css(".student-name").text #this works, now do it for all of them
    
    cards.each do |card|
      card_name = card.css(".student-name").text
      card_location = card.css(".student-location").text
      card_url = card.css("a")[0].attributes["href"].value
      students << {name: card_name, location: card_location, profile_url: card_url}
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    #student = {twitter: "", linkedin: "", github: "", blog: "", profile_quote: "", bio: ""}
    student = {}
    
    html = File.read(profile_url)
    doc = Nokogiri::HTML(html)

    scraped_links = doc.css(".social-icon-container").children.css("a")
    binding.pry
    student[:twitter] = doc.css(".social-icon-container").children.css("a").attribute("href").value
    #scraped_twitter = doc.css(".social-icon-container").children.css("a").attribute("href").value
    
    student[:linkedin] = doc.css(".social-icon-container").children.css("a")[1].attribute("href").value
    #scraped_linkedin = doc.css(".social-icon-container").children.css("a")[1].attribute("href").value
    
    if doc.css(".social-icon-container").children.css("a")[2]
      student[:github] = doc.css(".social-icon-container").children.css("a")[2].attribute("href").value
    end
    #scraped_github = doc.css(".social-icon-container").children.css("a")[2].attribute("href").value
    
    if doc.css(".social-icon-container").children.css("a")[3]
      student[:blog] = doc.css(".social-icon-container").children.css("a")[3].attribute("href").value
    end
    #scraped_blog = doc.css(".social-icon-container").children.css("a")[3].attribute("href").value
    
    student[:profile_quote] = doc.css(".profile-quote").text if doc.css(".profile-quote")
    #scraped_profile_quote = doc.css(".profile-quote").text #if doc.css(".profile-quote")
    
    if doc.css("div.bio-content.content-holder div.description-holder p").text
      student[:bio] = doc.css("div.bio-content.content-holder div.description-holder p").text
    end
    
    student
    
    #old code
    #student[:bio] = doc.css(".description-holder").text #if doc.css(".description-holder").text
    #scraped_bio = doc.css(".description-holder").text #if doc.css(".description-holder").text
    #student = {twitter: scraped_twitter, linkedin: scraped_linkedin, github: scraped_github, blog: scraped_blog, profile_quote: scraped_profile_quote, bio: scraped_bio}   
  end

end

