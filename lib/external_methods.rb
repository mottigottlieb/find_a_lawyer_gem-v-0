   
     
     
    	def self.has_number(id)
    	    status = nil
    	   	if @@track[id.to_i][:number].match(/[0-9]/)
    			status = true
    		else
    		  status = nil
    		end
    		    status
	    end 
	    
	      ############### External Methods ##########
        
    	def self.has_number(id)
    	    status = nil
    	   	if @@track[id.to_i][:number].match(/[0-9]/)
    			status = true
    		else
    		  status = nil
    		end
    		    status
	end
       
        
        def self.clear_and_greet
           @@id = 1
           self.track.clear 
           self.greet
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
        
        	def self.has_number(id)
    	    status = nil
    	   	if @@track[id.to_i][:number].match(/[0-9]/)
    			status = true
    		else
    		  status = nil
    		end
    		    status
	end
        def self.track
          @@track
        end
        
        def self.clear_and_greet
           @@id = 1
           self.track.clear 
           self.greet
        end
          
         