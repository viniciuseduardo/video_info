module VideoInfo
  class Videolog
    attr_accessor :video_id, :embed_code, :url, :provider, :title, :description, :keywords,
                  :duration, :date, :width, :height, :thumbnail, :view_count, :openURI_options

    def initialize(url, options = {})
      if iframe_attributes = options.delete(:iframe_attributes)
        @iframe_attributes = VideoInfo.hash_to_attributes iframe_attributes
      end

      @openURI_options = options
      video_id_for(url)
      get_info unless @video_id == url || @video_id.nil? || @video_id.empty?
    end

    def regex
      /videolog\.tv\/video\.php\?id=([0-9]*)?|videolog\.tv\/[^\/]+\/videos\/([0-9]*)/
    end

    def video_id_for(url)
      url.gsub(regex) do
        @video_id = $1 || $2
      end
    end

    private

    def get_info
      begin
        uri   = open("http://api.videolog.tv/video/#{@video_id}.json", @openURI_options)
        video = MultiJson.load(uri.read)
        @provider       = "Videolog"
        @url            = video['video']['link']
        @embed_code     = video['video']['embed'].strip
        @title          = video['video']['titulo']
        @description    = video['video']['texto']
        @keywords       = video['video']['tags']
        @duration       = video['video']['duracao']
        @date           = Time.parse(video['video']['criacao'], Time.now.utc)
        @thumbnail      = video['video']['thumb']
        @view_count     = video['video']['visitas'].to_i
      rescue
        nil
      end
    end
  end
end
