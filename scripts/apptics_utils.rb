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

  # Masks the host so the upload domain is not printed in logs
  def self.masked_url(url)
    "#{url.scheme}://#{url.host.to_s.gsub(/[^.]/, '*')}#{url.path}"
  end

  def self.upload
    url = nil
    begin
      unless File.exist?(@filepath)
        puts "Error: File not found - #{@filepath}"
        return
      end

      %i[apid mapid appversionid appreleaseversionid].each do |key|
        if @params[key].to_s.strip.empty?
          puts "Error: Missing required value '#{key}', dSYM not uploaded"
          return
        end
      end

      url = URI.parse(@urlstring)
      req = Net::HTTP::Post.new(url)

      upload_id = "#{@params[:appversionid]}_#{(Time.now.to_f * 1000).to_i}"
      puts "upload-id : #{upload_id}"

      # -------------------------------
      # Required Headers
      # -------------------------------
      req['mapid']               = @params[:mapid].to_s
      req['apid']                = @params[:apid].to_s
      req['appversionid']        = @params[:appversionid].to_s
      req['appreleaseversionid'] = @params[:appreleaseversionid].to_s
      req['upload-id']           = upload_id
      # Fixed values, to be sent as is
      req['x-service']           = 'apptics'
      req['x-streammode']        = '2'
      req['x-fclient-version']   = '2'
      req['x-filter-headers']    = 'mapid'
      req['author-zuid']         = '-1'
      req['content-type']        = 'application/zip'
      req['apptics-version']     = '1'
      req['module']              = 'dsym'

      # -------------------------------
      # Body : the zip file
      # -------------------------------
      File.open(@filepath, 'rb') do |zip|
        req.body_stream = zip
        req['content-length'] = File.size(@filepath).to_s

        res = Net::HTTP.start(
          url.host,
          url.port,
          use_ssl: url.scheme == "https",
          open_timeout: 60,
          read_timeout: 900
        ) do |http|
          http.request(req)
        end

        handle_response(res, url, upload_id)
      end

    rescue StandardError => e
      puts "Error: #{e.class} #{e.message} (#{url ? masked_url(url) : 'invalid url'})"
    end
  end

  def self.handle_response(res, url, upload_id)
    if res.code.to_i == 200
      puts "Success: dSYM uploaded (upload-id #{upload_id})"
    else
      error = res['x-error'].to_s.strip
      error = "Exception Occurred" if error.empty?
      puts "Error: #{error} (status #{res.code}, upload-id #{upload_id}, #{masked_url(url)})"
    end
  end

end
