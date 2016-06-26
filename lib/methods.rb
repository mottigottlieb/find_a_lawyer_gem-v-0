class Methods
    
    @@track=Hash.new
    @@id=1
     
     def self.track
          @@track
     end
     
     def has_number(id)
       status = nil
    	if @@track[id.to_i][:number].match(/[0-9]/)
    	  status = true
    	else
    	  status = nil
    	end
    	  status
     end
    
     def create_hash(index_url)
         site = @doc = Nokogiri::HTML(open(index_url))
            site.search("div.lawyer-search-result").map do |info|
              l_name = info.search("div h3").text
              l_practice = info.search("p.text-truncate").text
              l_rating = info.search("span.text-nowrap strong").text
              l_years =  info.search("time").text.delete("since ").to_i
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
             
     def greet
       puts "+------------------------------------------------+"
       puts "|             Welcome to Find A Lawyer           |"           
       puts "+------------------------------------------------+"
       puts "          Legal Issue (eg: Banktrupcy)?           "
        field = gets.strip
       puts "          Location (Zip Code, State, City)?       "
        location = gets.strip
       self.create_hash("https://www.avvo.com/search/lawyer_search?utf8=%E2%9C%93&q=#{field}&loc=#{location}&button=")
        
        if self.class.track.empty?
          puts "we haven't found any info"
          puts "Do you want to try again?(y/n)"
          answer = gets.strip
          self.greet if answer == "y" 
             puts "Thank you for Visiting"
             exit
          else
            puts "     We have found #{self.class.track.size} lawyer(s) in #{location} area      "  
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


       def clear_and_greet
           @@id = 1
           self.class.track.clear 
           self.greet
        end
      
        def has_phone?(id)
             @@track[id][:number] != ""
        end
          
      def results
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
eos
                            puts "                     #{@@track[chosen_lawyer.to_i][:number]}" if self.has_number(chosen_lawyer) == true
                        puts "                           Not found" if self.has_number(chosen_lawyer) == nil

       end
end