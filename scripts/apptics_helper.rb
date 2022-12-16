begin
    require "json"
    require 'cgi'
    rescue LoadError => error
    puts "error: #{error.message}, check if commandline tools are installed"
    exit
end

class AppticsEventsParser
            
    def self.main(metafilename)
        data_hash = JSON.parse(File.read("/tmp/#{metafilename}.json"))
        
        if data_hash == nil || data_hash["result"] != "success"
            puts "error: #{data_hash}"
            return false
        else
            data_hash=data_hash["data"]
        end
                
        plist_data = data_hash["plist"]
        if plist_data != nil
            out_file = File.new("/tmp/#{metafilename}.plist", "w")
            out_file.puts(plist_data)
            out_file.close
        else
            event_hash = data_hash["event"]
            api_hash = data_hash["api"]
            
            plist_fc = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            plist_fc.concat("<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n")
            plist_fc.concat("<plist version=\"1.0\">\n")
            plist_fc.concat("<dict>\n")
            plist_fc.concat("<key>EVENTS_INFO</key>\n")
            plist_fc.concat("<dict>\n")
            plist_fc.concat("<key>EVENTS</key>\n")
            plist_fc.concat("<dict>\n")
            
            plist_fc1 = "<key>GROUPS</key>\n"
            plist_fc1.concat("<dict>\n")
            if event_hash != nil
                event_hash.map do | group, groupInfo|
                    group = group.strip.gsub(/[^0-9A-Za-z]/, '_')
                    plist_fc.concat("<key>#{group}</key>\n")
                    plist_fc.concat("<dict>\n")
                    groupID = groupInfo["groupid"]
                    plist_fc1.concat("<key>#{group}</key>\n")
                    plist_fc1.concat("<string>#{groupID}</string>\n")
                    events = groupInfo["event"]
                    events.map do | name, id|
                        name = name.strip.gsub(/[^0-9A-Za-z]/, '_')
                        plist_fc.concat("<key>#{name}</key>\n")
                        plist_fc.concat("<string>#{id}</string>\n")
                    end
                    plist_fc.concat("</dict>\n")
                end
            end
            plist_fc1.concat("</dict>\n")
            plist_fc.concat("</dict>\n")
            
            plist_fc.concat(plist_fc1)
            
            plist_fc.concat("</dict>\n")
            
            plist_fc2="<key>API_INFO</key>\n"
            plist_fc2.concat("<dict>\n")
            
            plist_fc2.concat("<key>PATTERN_MATCH</key>\n")
            plist_fc2.concat("<array>\n")
            
            plist_fc3="<key>DIRECT_MATCH</key>\n"
            plist_fc3.concat("<array>\n")
            
            api_hash.map do | apiInfo|
                id = apiInfo["ID"]
                appID = apiInfo["AppID"]
                validationURL = apiInfo["ValidationURL"]
                type = apiInfo["Type"]
                url = CGI.escapeHTML(apiInfo["URL"])
                name = CGI.escapeHTML(apiInfo["Name"])
                isKey = apiInfo["IsKey"]
                
                if type == 1 || type == 2
                    plist_fc3.concat("<dict>\n")
                    plist_fc3.concat("<key>ID</key>\n")
                    plist_fc3.concat("<string>#{id}</string>\n")
                    plist_fc3.concat("<key>URL</key>\n")
                    plist_fc3.concat("<string>#{url}</string>\n")
                    plist_fc3.concat("<key>NAME</key>\n")
                    plist_fc3.concat("<string>#{name}</string>\n")
                    plist_fc3.concat("<key>APPID</key>\n")
                    plist_fc3.concat("<string>#{appID}</string>\n")
                    plist_fc3.concat("</dict>\n")
                else
                    plist_fc2.concat("<dict>\n")
                    plist_fc2.concat("<key>ID</key>\n")
                    plist_fc2.concat("<string>#{id}</string>\n")
                    plist_fc2.concat("<key>URL</key>\n")
                    plist_fc2.concat("<string>#{url}</string>\n")
                    plist_fc2.concat("<key>NAME</key>\n")
                    plist_fc2.concat("<string>#{name}</string>\n")
                    plist_fc2.concat("<key>APPID</key>\n")
                    plist_fc2.concat("<string>#{appID}</string>\n")
                    plist_fc2.concat("</dict>\n")
                end
                
            end
            plist_fc3.concat("</array>\n")
            
            plist_fc2.concat("</array>\n")
            
            plist_fc2.concat(plist_fc3)
            
            plist_fc2.concat("</dict>\n")
            plist_fc.concat(plist_fc2)
            
            plist_fc.concat("</dict>\n")
            plist_fc.concat("</plist>\n")
            out_file = File.new("/tmp/#{metafilename}.plist", "w")
            out_file.puts(plist_fc)
            out_file.close
        end
                
    end
    
end

