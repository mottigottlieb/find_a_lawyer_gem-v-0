require "find_a_lawyer_gem/version"
require 'nokogiri'
require 'pry'

module FindALawyerGem
    class Start
        def call
      methods = Methods.new
      scrape = Scrape.new
      methods.greet
    end
  end
end
