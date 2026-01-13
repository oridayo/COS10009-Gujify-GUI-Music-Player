require 'rubygems'
require 'gosu'
require 'waveinfo'

WIDTH = 1100
HEIGHT = 800

TOP_COLOR = Gosu::Color.new(0xFFFDE0E0)
BOTTOM_COLOR = Gosu::Color.new(0xFFFDAAAA)
VOLUME_BOTTOM = Gosu::Color.new(0xFFF97C7C)
VOLUME_TOP = Gosu::Color.new(0xFFF4C1C1)
TrackLeftX = 200
Ypos = 485

module ZOrder
  	BACKGROUND, PLAYER, UI = *0..2
end

class Cover
	attr_accessor :pic

	def initialize (file)
		@pic = Gosu::Image.new(file)
	end
end

#for album array
class Album
	attr_accessor :artist, :title, :artwork, :tracks

	def initialise(artist, title, artwork, tracks)
		  @artist = artist
		  @title = title
		  @artwork = artwork
		  @tracks = tracks
	end
  end

  #for track array
  class Track
	attr_accessor :name, :location

	def initialise(name, location)
		  @name = name
		  @location = location
	end
  end

class MusicPlayerMain < Gosu::Window

	def initialize
	    super WIDTH, HEIGHT, false
	    self.caption = "Gujify Music Player"
		@track_font = Gosu::Font.new(20)
		@background = BOTTOM_COLOR
		@highlight = BOTTOM_COLOR
		@player = TOP_COLOR
		@song_start = 0
		@pause_time = 0
		@volume = 0.5
		@albums = read_albums()
		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
		@current_song = 0
		@album_id = 0
		@album = @albums[@album_id]
		play_track(@current_song)
	end

  	# Put in your code here to load albums and tracks
  	def read_albums()
	  	albums = Array.new()
	  	file_name = "albums.txt"
	  	file = File.open(file_name, "r")
	  	count = file.gets.to_i()
	  	i = 0
	  	while (i < count)
		  	album = read_album(file)
		  	albums << album
		  	i += 1
	  	end
  
	  	puts("Album read successful!")
	  	file.close()
  
	  	return albums
  	end
  
  	def read_album(file)
		album = Album.new()
  
		album.artist = file.gets()
		album.title = file.gets()
		album.artwork = file.gets()
		album.tracks = read_tracks(file)
  
		return album
  	end
  
  	def read_track(file)
		track = Track.new()
  
		track.name = file.gets()
		track.location = file.gets()
  
		return track
  	end
  
  	def read_tracks(file)
		tracks = Array.new()
		count = file.gets.to_i()
		i = 0
  
		while (i < count)
	  		tracks << read_track(file)
	  		i += 1
		end
  
		return tracks
  	end

  	def play_track(id)
		@location = @albums[@album_id].tracks[id].location.chomp
		@current_song = id
		@song = Gosu::Song.new(@location)
		@song.play(false)
		@song.volume = 1.0
		@song_start = Gosu.milliseconds
		@pause_time = Gosu.milliseconds
		@song.volume = @volume
  	end

	def autoplay
		if @song.playing? == false && @song.paused? == false
			sleep(2)
			if @current_song < @album.tracks.length-1 
				@current_song += 1
				play_track(@current_song)
			else 
				if @album_id == @albums.length - 1
					@album_id = 0
					@album = @albums[@album_id]
					@current_song = 0
					play_track(@current_song)
				else
					@album_id += 1
					@album = @albums[@album_id]
					@current_song = 0
					play_track(@current_song)
				end
			end
		end
	end

  	# Draws the artwork on the screen for all the albums
  	def draw_albums
		case @album_id
		when 0
			@album_image = Cover.new("media/album0.jpg")
			@right = Cover.new("media/arrow.png")
    		@album_image.pic.draw(100,100, ZOrder::PLAYER, scale_x = 0.5, scale_y = 0.5)
			@right.pic.draw(550,300, ZOrder::UI, 0.1, 0.1)
		when 1
			@album_image = Cover.new("media/album1.jpg")
			@left = Cover.new("media/arrow2.png")
			@right = Cover.new("media/arrow.png")
    		@album_image.pic.draw(100,100, ZOrder::PLAYER, scale_x = 1.25, scale_y = 1.25)
			@right.pic.draw(550,300, ZOrder::UI, 0.1, 0.1)
			@left.pic.draw(-10, 300, ZOrder::UI, 0.1, 0.1)
		when 2
			@album_image = Cover.new("media/album2.jpg")
			@left = Cover.new("media/arrow2.png")
			@right = Cover.new("media/arrow.png")
    		@album_image.pic.draw(100,100, ZOrder::PLAYER, scale_x = 1.25, scale_y = 1.25)
			@right.pic.draw(550,300, ZOrder::UI, 0.1, 0.1)
			@left.pic.draw(-10, 300, ZOrder::UI, 0.1, 0.1)
		when 3
			@album_image = Cover.new("media/album3.jpg")
			@left = Cover.new("media/arrow2.png")
    		@album_image.pic.draw(100,100, ZOrder::PLAYER, scale_x = 0.5, scale_y = 0.5)
			@left.pic.draw(-10, 300, ZOrder::UI, 0.1, 0.1)
		end
  	end

  	# Detects if a 'mouse sensitive' area has been clicked on
  	# i.e either an album or a track. returns true or false
  	def area_clicked(mouse_x, mouse_y)
		if (mouse_y < 642 && mouse_y> 545) then
			if (mouse_x < 548 && mouse_x > 454) then
		   		return 5
			elsif (mouse_x < 445 && mouse_x > 353) then
		   		return 4
			elsif (mouse_x < 342 && mouse_x > 250) then
		   		return 3
			elsif (mouse_x < 241 && mouse_x > 148) then
		   		return 2
			elsif (mouse_x < 138 && mouse_x > 42) then
		   		return 1
			end
		elsif (mouse_y < 720 && mouse_y > 670) then
			if (mouse_x < 100 && mouse_x > 40) then
				return 6
			elsif (mouse_x < 560 && mouse_x > 500) then
				return 7
			end
		elsif (mouse_y < 350 && mouse_y > 300) then 
			if (mouse_x < 40 && mouse_x > 0) then 
				return 8
			elsif (mouse_x < 600 && mouse_x > 550) then
				return 9
			end
	  	end
  	end

	def album_clicked(mouse_x, mouse_y)
		if(mouse_x > 620 && mouse_x < 1050) then
			if (mouse_y > 80 && mouse_y < 120) then
				return 1
			elsif(mouse_y > 120 && mouse_y < 160) then
				return 2
			elsif(mouse_y > 160 && mouse_y < 200) then
				return 3
			elsif(mouse_y > 200 && mouse_y < 240) then
				return 4
			end
		end
	end

	def track_clicked(mouse_x, mouse_y)
		if (mouse_x > 620 && mouse_x < 1050) then
			y = 300
			for i in 0..@album.tracks.length-1 do
				y += 40
				if (mouse_y > y && mouse_y < (y+40) )
				return i
				end
			end
		end
	end

	def volume_slider()
		if @song.volume <= 0.1
			@element = Cover.new("media/volume0.bmp")
			@element.pic.draw(100, 665, ZOrder::UI)
		elsif @song.volume <= 0.2
			@element = Cover.new("media/volume1.bmp")
			@element.pic.draw(100, 665, ZOrder::UI)
		elsif @song.volume <= 0.3
			@element = Cover.new("media/volume2.bmp")
			@element.pic.draw(100, 665, ZOrder::UI)
		elsif @song.volume <= 0.4
			@element = Cover.new("media/volume3.bmp")
			@element.pic.draw(100, 665, ZOrder::UI)
		elsif @song.volume <= 0.5
			@element = Cover.new("media/volume4.bmp")
			@element.pic.draw(100, 665, ZOrder::UI)
		elsif @song.volume <= 0.6
			@element = Cover.new("media/volume5.bmp")
			@element.pic.draw(100, 665, ZOrder::UI)
		elsif @song.volume <= 0.7
			@element = Cover.new("media/volume6.bmp")
			@element.pic.draw(100, 665, ZOrder::UI)
		elsif @song.volume <= 0.8
			@element = Cover.new("media/volume7.bmp")
			@element.pic.draw(100, 665, ZOrder::UI)
		elsif @song.volume <= 0.9
			@element = Cover.new("media/volume8.bmp")
			@element.pic.draw(100, 665, ZOrder::UI)
		elsif @song.volume <= 1.0
			@element = Cover.new("media/volume9.bmp")
			@element.pic.draw(100, 665, ZOrder::UI)
		end
	end

	def draw_album_name
		i = 0
		albumy = 40
		title = "Albums"
		@track_font.draw_markup(title, 620, albumy, ZOrder::UI, 1, 1, Gosu::Color::BLACK, mode = :default)
		while i < @albums.length
			albumy += 40
			title = (i+1).to_s.chomp + ". " + @albums[i].title.chomp + " by " + @albums[i].artist.chomp
			@track_font.draw_markup(title, 620, albumy, ZOrder::UI, 1, 1, Gosu::Color::BLACK, mode = :default)
			i += 1
		end
	end

	def draw_track_name
		i = 0
		tracky = 300
		title = "Tracks"
		@track_font.draw_markup(title, 620, tracky, ZOrder::UI, 1, 1, Gosu::Color::BLACK, mode = :default)
		while i < @album.tracks.length
			tracky += 40
			title = (i+1).to_s.chomp + ". " + @album.tracks[i].name.chomp
			@track_font.draw_markup(title, 620, tracky, ZOrder::UI, 1, 1, Gosu::Color::BLACK, mode = :default)
			location =  @albums[@album_id].tracks[i].location.chomp
			wave = WaveInfo.new(location)
			song_length = wave.duration.to_i
			song_min = (song_length / 60).to_i
			song_sec = "%02d"%(song_length % 60)
			song_total_length = song_min.to_s+":"+song_sec
			@track_font.draw_markup(song_total_length, 1000, tracky, ZOrder::UI, 1, 1, Gosu::Color::BLACK, mode = :default)
			i += 1
		end
	end

  	def display_track(title)
		title2 = @album.title.chomp + " from " + @album.artist.chomp
  		@track_font.draw_markup(title, TrackLeftX, Ypos, ZOrder::PLAYER, scale_x = 1, scale_y = 1, Gosu::Color::BLACK, mode = :default)
		@track_font.draw_markup(title2, 150, 70, ZOrder::PLAYER, 1, 1, Gosu::Color::BLACK, mode = :default)
  	end

	def draw_time_played()
		if @song.playing?
			@pause_time = (Gosu.milliseconds - @song_start) / 1000
		end
		time_min = "%01d"%(@pause_time / 60)
		time_sec = "%02d"%(@pause_time%60)
		time_total_length = time_min+":"+time_sec
		wave = WaveInfo.new(@location)
		song_length = wave.duration.to_i
		song_min = (song_length / 60).to_i
		song_sec = "%02d"%(song_length % 60)
		song_total_length = song_min.to_s+":"+song_sec
		title = "#{time_total_length}/#{song_total_length}"
		@track_font.draw_markup(title, 250, 530, ZOrder::PLAYER, 1, 1, Gosu::Color::BLACK)
	end

  	def draw_buttons()
    	@media_buttons = Cover.new("media/mediabuttons.png")
		@volume_buttons = Cover.new("media/volumebuttons.png")
    	@media_buttons.pic.draw(45, 550, ZOrder::UI)
		@volume_buttons.pic.draw(40, 670, ZOrder::UI)

  	end

	# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR
	def draw_background
		Gosu.draw_rect(0, 0, WIDTH, HEIGHT, @background, ZOrder::BACKGROUND, mode=:default)
        Gosu.draw_rect(40, 40, 510, 710, @player, ZOrder::PLAYER, mode=:default)
		
		title = "Now Playing "+ (@current_song+1).to_s.chomp + ". " + @album.tracks[@current_song].name.chomp
        draw_albums()
		display_track(title)
		draw_buttons()
		volume_slider()
	end

	def highlight_album(id)
		
		case id
		when 0
			Gosu.draw_rect(620, 80, 430, 40, TOP_COLOR, ZOrder::PLAYER, mode=:default)
		when 1
			Gosu.draw_rect(620, 120, 430, 40, TOP_COLOR, ZOrder::PLAYER, mode=:default)
		when 2
			Gosu.draw_rect(620, 160, 430, 40, TOP_COLOR, ZOrder::PLAYER, mode=:default)
		when 3
			Gosu.draw_rect(620, 200, 430, 40, TOP_COLOR, ZOrder::PLAYER, mode=:default)
		end
	end

	def highlight_track(id)
		y = 300
		for i in 0..@album.tracks.length-1 do
			y += 40
			if id == i
				Gosu.draw_rect(620, y, 430, 40, TOP_COLOR, ZOrder::PLAYER, mode=:default)
			end
		end
	end


	def draw
		draw_background
		draw_album_name
		draw_track_name
		draw_time_played
		highlight_album(@album_id)
		highlight_track(@current_song)

		if album_clicked(mouse_x, mouse_y) == 1
			Gosu.draw_rect(620, 80, 430, 40, TOP_COLOR, ZOrder::PLAYER, mode=:default)
		elsif album_clicked(mouse_x, mouse_y) == 2
			Gosu.draw_rect(620, 120, 430, 40, TOP_COLOR, ZOrder::PLAYER, mode=:default)
		elsif album_clicked(mouse_x, mouse_y) == 3
			Gosu.draw_rect(620, 160, 430, 40, TOP_COLOR, ZOrder::PLAYER, mode=:default)
		elsif album_clicked(mouse_x, mouse_y) == 4
			Gosu.draw_rect(620, 200, 430, 40, TOP_COLOR, ZOrder::PLAYER, mode=:default)
		end

		y = 300
		for i in 0..@album.tracks.length-1 do
			y += 40
			if track_clicked(mouse_x, mouse_y) == i
				Gosu.draw_rect(620, y, 430, 40, TOP_COLOR, ZOrder::PLAYER, mode=:default)
			end
		end
	end

	def update
		autoplay
	end
	
 	def needs_cursor?; true; end

	def button_down(id)
		case id
			when Gosu::MsLeft
				button = area_clicked(mouse_x,mouse_y)
				case button
					when 1
						if @current_song > 0 
							@current_song -= 1
							play_track(@current_song)
						else
							if @album_id == 0
								@album_id = @albums.length - 1
								@album = @albums[@album_id]
								@current_song = @album.tracks.length-1
								play_track(@current_song)
							else
								@album_id -= 1
								@album = @albums[@album_id]
								@current_song = @album.tracks.length-1
								play_track(@current_song)
							end
						end
					
					when 2
						@song.stop
						exit
					
					when 3
						@song.play(false)
						@song_start =  @pause_time - @song_start
						
					
					when 4
						@song.pause
					
					when 5
						if @current_song < @album.tracks.length-1 
							@current_song += 1
							play_track(@current_song)
						else 
							if @album_id == @albums.length - 1
								@album_id = 0
								@album = @albums[@album_id]
								@current_song = 0
								play_track(@current_song)
							else
								@album_id += 1
								@album = @albums[@album_id]
								@current_song = 0
								play_track(@current_song)
							end
						end

					when 6
						if @volume > 0.05
							@volume -= 0.1
							@song.volume = @volume
						end
					
					when 7
						if @volume < 0.95
							@volume += 0.1
							@song.volume = @volume
						end
					when 8 
						if @album_id > 0
							@album_id -= 1
							@album = @albums[@album_id]
							@current_song = 0
							play_track(@current_song)
						end
					when 9
						if @album_id < @albums.length - 1
							@album_id += 1
							@album = @albums[@album_id]
							@current_song = 0
							play_track(@current_song)
						end
				end

				case album_clicked(mouse_x, mouse_y)
					when 1
						if @album_id != 0
							@album_id = 0
							@album = @albums[@album_id]
							@current_song = 0
							play_track(@current_song)
						end
					when 2
						if @album_id != 1
							@album_id = 1
							@album = @albums[@album_id]
							@current_song = 0
							play_track(@current_song)
						end
					when 3
						if @album_id != 2
							@album_id =2
							@album = @albums[@album_id]
							@current_song = 0
							play_track(@current_song)
						end
					when 4
						if @album_id != 3
							@album_id = 3
							@album = @albums[@album_id]
							@current_song = 0
							play_track(@current_song)
						end
				end

				for i in 0..@album.tracks.length-1 do
					if track_clicked(mouse_x, mouse_y) == i
						if @current_song != i
							@current_song = i
							play_track(@current_song)
						end
					end
				end


			when Gosu::KbK
				if @song.play(false)
					@song.stop
				else
					@song.play(false)
				end
			
			when Gosu::KbDown
				if @song.volume > 0.05 
					@song.volume -= 0.1
				end
			
			when Gosu::KbUp
				if @song.volume < 0.95  
					@song.volume += 0.1
				end
			
			when Gosu::KbRight
				if @current_song < @album.tracks.length-1 
					@current_song += 1
					play_track(@current_song)
				else 
					if @album_id == @albums.length - 1
						@album_id = 0
						@album = @albums[@album_id]
						@current_song = 0
						play_track(@current_song)
					else
						@album_id += 1
						@album = @albums[@album_id]
						@current_song = 0
						play_track(@current_song)
					end
				end
			
			when Gosu::KbLeft
				if @current_song > 0 
					@current_song -= 1
					play_track(@current_song)
				else
					if @album_id == 0
						@album_id = @albums.length - 1
						@album = @albums[@album_id]
						@current_song = @album.tracks.length-1
						play_track(@current_song)
					else
						@album_id -= 1
						@album = @albums[@album_id]
						@current_song = @album.tracks.length-1
						play_track(@current_song)
					end
				end
			
		end
	end
end

MusicPlayerMain.new.show