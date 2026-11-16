begin
  require "net/http"
  require "json"
  require "uri"
rescue LoadError => error
  puts "Error: #{error.message}, check if commandline tools are installed"
  exit 1
end


# ------------------------------------------------------------
#  Parses version registration API response
# ------------------------------------------------------------
class AppticsBot

  def self.main(file_path)
    begin
      data_hash = JSON.parse(File.read(file_path))

      if data_hash["result"] == "failure"
        puts "Error: #{data_hash['error_message']}"
        return false
      end

      data = data_hash["data"]

      if data.nil?
        puts "Error: Invalid entries found in the response"
        return false
      end

      puts "export appversionid=#{data['appversionid']}"
      puts "export appreleaseversionid=#{data['appreleaseversionid']}"
      puts "export aaid=#{data['aaid']}"
      puts "export apid=#{data['apid']}"
      puts "export mapid=#{data['mapid']}"
      puts "export rsakey=#{data['rsakey']}"
      puts "export platformid=#{data['platformid']}"
      puts "export portalid=#{data['portalid']}"
      puts "export projectid=#{data['projectid']}"

    rescue StandardError => e
      puts "Error: #{e}"
      return false
    end
  end

end



# ------------------------------------------------------------
#  Uploads dSYM build file
# ------------------------------------------------------------
class AppticsUploader

  def self.main(filepath, urlstring, token, params = {})
    @filepath  = filepath
    @urlstring = urlstring
    @token     = token
    @params    = params
    upload
  end

  def self.valid_json?(string)
    JSON.parse(string)
    true
  rescue JSON::ParserError
    false
  end

  def self.upload
    begin
      unless File.exist?(@filepath)
        puts "Error: File not found - #{@filepath}"
        return
      end

      url = URI.parse(@urlstring)
      req = Net::HTTP::Post.new(url)

      # -------------------------------
      # Required Headers
      # -------------------------------
      req['zak']   = @token
      req['apid']  = @params[:apid].to_s
      req['mapid'] = @params[:mapid].to_s

      # -------------------------------
      # Multipart Form Data
      # -------------------------------
      form_data = []

      @params.each do |key, value|
        next if key == :apid || key == :mapid
        form_data << [key.to_s, value.to_s]
      end

      File.open(@filepath) do |zip|
        form_data << ['buildfile', zip]
        req.set_form(form_data, 'multipart/form-data')

        res = Net::HTTP.start(
          url.host,
          url.port,
          use_ssl: url.scheme == "https",
          open_timeout: 60,
          read_timeout: 900
        ) do |http|
          http.request(req)
        end

        handle_response(res)
      end

    rescue StandardError => e
      puts "Error: #{e}"
    end
  end

  def self.handle_response(res)
    if valid_json?(res.body)
      data_hash = JSON.parse(res.body)

      if data_hash["result"] == "success"
        puts "Success: #{data_hash['data']}"
      else
        puts "Error: #{data_hash['error_message']}"
      end
    else
      puts "Error: #{res.body}"
    end
  end

end
