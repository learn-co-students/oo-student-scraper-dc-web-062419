require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index = Nokogiri::HTML(html)
    students = index.css("div.student-card")
    students_array = []
    # binding.pry # check what "students" returns
    students.each do |student|
      # binding.pry # check what "student" returns - should only be one student
      students_array << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
    end
    students_array
    # binding.pry # check what the function returns; should be an array of hashes
  end

  def self.scrape_profile_page(student_url)
    html = File.read(student_url)
    profile = Nokogiri::HTML(html)
    # get chunks of css that contain the stuff I need
    student = profile.css("div.vitals-container")
    student_bio = profile.css("div.description-holder")
    # create and array with all the social media links
    links = student.css("div.social-icon-container a").map{|link| link.attribute("href").value}
    # define variables for each social media link
    twitter = links.find{|e| e.include? 'twitter.com'}
    linkedin = links.find{|e| e.include? 'linkedin.com'}
    github = links.find{|e| e.include? 'github.com'}
    blog = links.find{|e|
      !e.include?('twitter.com') &&
      !e.include?('linkedin.com') &&
      !e.include?('github.com')}
    # add links to the student_hash if they exist
    student_hash = {}
    twitter ? student_hash[:twitter] = twitter : student_hash
    linkedin ? student_hash[:linkedin] = linkedin : student_hash
    github ? student_hash[:github] = github : student_hash
    blog ? student_hash[:blog] = blog : student_hash
    # add text to the student_hash that should exist
    student_hash[:profile_quote] = student.css("div.vitals-text-container div.profile-quote").text
    student_hash[:bio] = student_bio.css("p").text
    student_hash
  end
end

# scrape_index_page("../fixtures/student-site/index.html")
