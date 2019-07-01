require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    html = Nokogiri::HTML(open(index_url))
    html.css('div.student-card').each do |student|
      students << {
        :name => student.css('h4.student-name').text,
        :location => student.css('p.student-location').text,
        :profile_url => student.css('a').attribute('href').value
      }
    end
    return students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    html = Nokogiri::HTML(open(profile_url))

    student[:profile_quote] = html.css('.profile-quote').text if html.css('.profile-quote')
    student[:bio] = html.css('div.description-holder p').text if html.css('.description-holder p')

    links = html.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
    links.each do |link|
      if link.include?('linkedin')
        student[:linkedin] = link
      elsif link.include?('twitter')
        student[:twitter] = link
      elsif link.include?('github')
        student[:github] = link
      else
        student[:blog] = link
      end
    end
    return student
  end
end