# frozen_string_literal: true

require 'youtube-dl.rb'

module Muvy
  class Download
    attr_reader :media, :options

    def initialize(media, options = {})
      @media = media
      @options = options.to_hash
    end

    def run
      download_video
      send_video
    end

    def download_video
      vid = YoutubeDL.download(media, settings)

      puts <<~DOWNLOADED
        Download complete.
        Video title: #{vid.information[:title]}
        Video URL: #{vid.information[:webpage_url]}
        Video format: #{vid.information[:format]} saved as #{vid.information[:ext]}
          as #{vid.information[:_filename]}
        File size: #{(vid.information[:filesize] / 1.024e6).round(2)} MB.
      DOWNLOADED

      # Add important settings to @options hash for use by FFmpeg
      options[:fps] = vid.information.fps
      options[:media_length] = vid.information.duration
    end

    def send_video
      # Video.new(SETTINGS[:output], SETTINGS).run if File.exists?(SETTINGS[:output])
    rescue
      # things
    ensure
      # delete the downloaded directory + videos if it didn't work failsafe
    end

    def settings
      defaults = {
        continue: false,
        format: :worstvideo,
        output: options[:path] +
                "/tmp/ruby-muvy_video_downloads/" +
                Time.now.strftime("%d_%m_%Y_%H%M") +
                ".mp4"
      }

      defaults.merge(options.select { |k| defaults.key?(k) })
    end
  end
end
