class Song
  attr_reader :track_id, :track_name, :artist, :lyrics, :youtube_link

  def initialize(track_info)
    @track_id = track_info[:track][:track_id]
    @track_name = track_info[:track][:track_name]
    @artist = track_info[:track][:artist_name]
    @lyrics ||= track_lyrics
    @youtube_link ||= track_youtube_link
  end

  private

  def track_lyrics
    service = MusixMatchService.new(nil, @track_id)
    response = service.get_lyrics
    lyrics = response[:message][:body][:lyrics][:lyrics_body]
    lyric_sanitizer(lyrics)
  end

  def lyric_sanitizer(song_lyrics)
    song_lyrics.gsub("\n\n******* This Lyrics is NOT for Commercial use *******\n", "")
  end

  def track_youtube_link
    service = YouTubeService.new(@track_name, @artist)
    service.get_youtube_link
  end

end