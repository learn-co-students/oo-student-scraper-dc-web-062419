require 'pry'
class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def initialize(student_hash)
    student_hash.each do |attribute, value| 
      self.send("#{attribute}=", value)
    end
    self.class.all << self
  end

  def self.create_from_collection(students_array)
    students_array.each {|student_hash| Student.new(student_hash)}
  end

  def add_student_attributes(attributes_hash)
    attributes_hash.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
    # @twitter = student_hash[:twitter]
    # @linkedin = student_hash[:linkedin]
    # @github = student_hash[:github]
    # @blog = student_hash[:blog]
    # @profile_quote = student_hash[:profile_quote]
    # @bio = student_hash[:bio]
  end

  def self.all
    @@all
  end
end

