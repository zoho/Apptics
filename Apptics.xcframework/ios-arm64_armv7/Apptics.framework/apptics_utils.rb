begin
require "net/http"
require "json"
rescue LoadError => error
  puts "echo #{error.message}, check if commandline tools are installed"
  exit
end

class AppticsBot

  def self.main(filePath)
    
    data_hash = JSON.parse(File.read(filePath))
    
    data_hash = data_hash["data"]
    
    if data_hash == nil
      puts "echo 'Invalid entries found in the response'"
      return false
    end
       
    puts "export appversionid=#{data_hash['appversionid']}"
    puts "export appreleaseversionid=#{data_hash['appreleaseversionid']}"
    puts "export aaid=#{data_hash['aaid']}"
    puts "export apid=#{data_hash['apid']}"
    puts "export mapid=#{data_hash['mapid']}"
    puts "export rsakey=#{data_hash['rsakey']}"
    puts "export platformid=#{data_hash['platformid']}"
    
  end
  
end

class AppticsUploader

    def self.main(filepath, urlstring, token)
      @filepath = filepath
      @urlstring = urlstring
      @token = token
      upload()
    end
    
    def self.valid_json?(string)
      !!JSON.parse(string)
    rescue JSON::ParserError
      false
    end

    def self.upload()
        url = URI.parse(@urlstring)
        File.open(@filepath) do |zip|
          req = Net::HTTP::Post.new(url)
          form_data = [['dsymfile', zip]]
          req.set_form form_data, 'multipart/form-data'
          req['zak']=@token
          res = Net::HTTP.start(url.host, url.port, use_ssl: true, open_timeout:60, read_timeout: 300) do |http|
          http.request(req)
          end
          
        # Status
        puts res.code       # => '200'
        puts res.class.name # => 'HTTPOK'

        # Body
        if valid_json?(res.body)
        data_hash = JSON.parse(res.body)
        puts "dSYM upload status : #{data_hash['result']}"
        if data_hash["result"] == "success"
              puts "data : #{data_hash['data']}"
              else
              puts "error_message : #{data_hash['error_message']}"
        end
        else
          puts res.body
        end
        end
    end
end
