require 'pry'

class Scraper

  index_url = '../fixtures/student-site/index.html'
# binding.pry

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    scraped_students = []
    page.css("div.student-card").each do |student|
      stud_name = student.css("h4").text
      # binding.pry
      name = stud_name
      stud_name = {}
      location = student.css("p.student-location").text
      profile_url = student.css("a").attribute("href").value
      stud_name[:name] = name
      stud_name[:location] = location
      stud_name[:profile_url] = profile_url
      scraped_students << stud_name
      # binding.pry
    end
    # binding.pry
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    name = page.css("h1.profile-name").text
    name_text = name
    name = {}
    # name[:name] = name_text
    page.css("div.social-icon-container a").each do |social| 
      if social.attribute("href").value.include?("twitter")
        name[:twitter] = social.attribute("href").value
      elsif social.attribute("href").value.include?("linkedin")
        name[:linkedin] = social.attribute("href").value
      elsif social.attribute("href").value.include?("github")
        name[:github] = social.attribute("href").value 
      else
        name[:blog] = social.attribute("href").value
      end
    end
    name[:profile_quote] = page.css("div.profile-quote").text 
    name[:bio] = page.css("div.description-holder p").text
    # name[:twitter] = if page.css("div.social-icon-container a").attribute("href").value.include?("twitter") 
    #     page.css("div.social-icon-container a").attribute("href").value
    #   end
    # name[:linkedin] = if page.css("div.social-icon-container a").attribute("href").value.include?("linkedin") 
    #     page.css("div.social-icon-container a").attribute("href").value
    #   end
    # binding.pry
    name
  end

end

