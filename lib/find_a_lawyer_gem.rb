require "find_a_lawyer_gem/version"

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
           l_number = info.search("ul li span .gc-cs-link").text
          
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
       puts "----------------------"
        puts "Please enter the number of lawyer you want more info on"
           chosen_lawyer = gets.strip
           puts <<eos
                ############### Name: ###############
                #{@@track[chosen_lawyer.to_i][:name]}
                -------------- Practice: ------------
                #{@@track[chosen_lawyer.to_i][:practice]}
                ------------- Avvo Rating: -----------
                #{@@track[chosen_lawyer.to_i][:rating]}
                ----------- Years Licensed: -----------
                #{@@track[chosen_lawyer.to_i][:years]}
                ----------- Phone Number: -----------
                #Needs to get scraped
                ######################################
eos
   end
   
   
  
        def self.greet
        puts "Welcome to Find a Lawyer."
        puts "What Legal Issue do you need help with?"
            field = gets.strip
           puts "What's your zip code?"
           zipcode = gets.strip
            Scrape.create_hash("https://www.avvo.com/search/lawyer_search?utf8=%E2%9C%93&q=#{field}&loc=#{zipcode}&button=")
            
            if self.track.empty?
                puts "we haven't found any info"
                puts "Do you want to try again?(y/n)"
                
                answer = gets.strip
                
                self.greet if answer == "y"
                
                puts "Thank you for Visiting"
                exit
            else
           puts "We have found the following #{self.track.size} in the #{zipcode} area" 
            @@track.each do |idx, name|
            puts "----------------------"
           puts "#{idx}. #{name[:name]}"
                
        end
               self.results
            puts "do you want to see additional options?(y/n)"       
            
            options = gets.strip
            
         case options
                when "y"
                    puts "1. see more info on another lawyer"
                    puts "2. search for another legal issue"
                    
                    a = gets.strip
                    self.results if a == "1"
                  self.clear_and_greet if a =="2"
                    
                    
                    
                else
                    puts "Exiting the program"
                    exit
            end 
        
    
        end
      
  end
  
    # binding.pry
   
end 
end
