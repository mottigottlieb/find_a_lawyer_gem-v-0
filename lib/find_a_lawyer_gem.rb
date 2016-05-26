require "find_a_lawyer_gem/version"
require 'nokogiri'
require 'pry'

module FindALawyerGem
    
      class Scrape
        
        @@track=Hash.new
        @@id=1
        #scrape url 
         def self.create_hash(index_url)
             @doc = Nokogiri::HTML(open(index_url))
             container = @doc.search("div.lawyer-search-result").map do |info|
               l_name = info.search("div h3").text
               l_practice = info.search("p.text-truncate").text
               l_rating = info.search("span.text-nowrap strong").text
               l_years =  info.search("time").text.delete("since ").to_i
              
             #  l_number = info.search("ul li span .gc-cs-link").text
                l_number = info.search("span.hidden-xs").text
               
                
              time = Time.now  
            
              @@track[@@id]={    
                            :name => l_name,
                            :practice => l_practice,    
                            :rating => l_rating,
                            :years => time.year-l_years,
                            :number => l_number
                            } 
                          @@id += 1
                 end  
         end  
        
        ############### External Methods ##########
        
        def self.track
          @@track
        end
        
        def self.clear_and_greet
           @@id = 1
           self.track.clear 
           self.greet
        end
         
        def self.results
           puts "___________"
           puts "Please enter the number of lawyer you want more info on"
           chosen_lawyer = gets.strip 
               puts <<eos 
                                       Lawyer ##{chosen_lawyer}                     
                    +------------------------------------------------+
                      Name:                                          
                           #{@@track[chosen_lawyer.to_i][:name]}        
                      Practice:                                      
                           #{@@track[chosen_lawyer.to_i][:practice].slice(25..400)}                                         
                      Avvo Rating:                                   
                           #{@@track[chosen_lawyer.to_i][:rating]}      
                      Years Licensed:                                
                           #{@@track[chosen_lawyer.to_i][:years]}                   
                      Phone Number:                        
                        #{@@track[chosen_lawyer.to_i][:number]}                                   
                    +------------------------------------------------+
eos
       end
       
       def self.greet
          puts "+------------------------------------------------+"
          puts "|             Welcome to Find A Lawyer           |"           
          puts "+------------------------------------------------+"
          puts "          Legal Issue (eg: Banktrupcy)?           "
            field = gets.strip
          puts "          Location (Zip Code, State, City)?       "
            location = gets.strip
          Scrape.create_hash("https://www.avvo.com/search/lawyer_search?utf8=%E2%9C%93&q=#{field}&loc=#{location}&button=")
                
                if self.track.empty?
                    puts "we haven't found any info"
                    puts "Do you want to try again?(y/n)"
                    answer = gets.strip
                    self.greet if answer == "y" 
                    puts "Thank you for Visiting"
                    exit
                else
               puts "     We have found #{self.track.size} lawyer(s) in #{location} area      "  
                @@track.each do |idx, name|  
               puts "              #{idx}. #{name[:name]}         "
                    
            end
                   self.results
                   
                puts "do you want to see additional options?(y/n)"       
                options = gets.strip
                
             case options
               when "y"
                 puts "1. see details of another lawyer"
                 puts "2. search for other legal issue"
                 answer = gets.strip
                 self.results if answer == "1"
                 self.clear_and_greet if answer =="2"
               else
                  puts "Exiting the program"
                  exit
                end 
             end
        end
    end # End Scrape class
end #End module 
