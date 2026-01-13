require './input_functions'
require 'gosu'
require 'rubygems'

#for album array
class Album
  attr_accessor :artist, :title, :date, :genre, :tracks

  def initialise(artist, title, date, genre, tracks)
    @artist = artist
    @title = title
    @date = date
    @genre = genre
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

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

#Main Menu Option 1: Read Albums
def read_albums()
    albums = Array.new()
    file_name = read_string("Please enter a file:")
	file = File.open(file_name, "r")
    count = file.gets.to_i()
    i = 0
    while (i < 4)
        album = read_album(file)
        albums << album
        i += 1
    end

    puts("Album read successful! Press ENTER to continue")
    file.close()

    return albums
end

def read_album(file)
  album = Album.new()

  album.artist = file.gets()
  album.title = file.gets()
  album.date = file.gets()
  album.genre = file.gets.to_i()
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

#Main Menu Option 2: Display Album
def display_albums(albums)
  finished = false
  begin
    puts("Display Albums:")
    puts("1 - Disaply All")
    puts("2 - Display Genre")
    puts("3 - Back")

    choice = read_integer_in_range("Please enter your choice:", 1, 3)
    case choice
      when 1
        display_all(albums)
        gets()
      when 2
        display_genre(albums)
        gets()
      when 3
        finished = true
      else
        puts("Invalid selection")
    end
  end until finished
end

def display_all(albums)
  i = 0
  while (i < albums.length)
    display_album(albums[i], i)
    i += 1
  end
  puts ("Press ENTER to continue")
end

def display_album(album, i)
  puts ("Album UID: " + (i+1).to_s)
  puts ("~ " + $genre_names[album.genre] + " ~")
  puts (album.date)
  puts ("#{album.title} by #{album.artist}\n")
end

def display_genre(albums)
  puts ("Display Genre")
  puts ("-------------")
  puts ("1 - Pop")
  puts ("2 - Classic")
  puts ("3 - Jazz")
  puts ("4 - Rock")
  search_int = read_integer_in_range("Please enter an option: ", 1, 4)
  genre_search(albums, search_int)
  puts ("Press ENTER to continue")
end

def genre_search(albums, search_int)
  found = Array.new()
  i = 0
  while i < albums.length
    if albums[i].genre.to_i() == search_int
      found << i
    end
    i += 1
  end

  if (found.length != 0)
    i = 0
    while i < found.length
      display_album(albums[found[i]], found[i])
      i += 1
    end
  else
   puts ("Entry not found!")
  end
end

#Main Menu Option 3: Play Album
def play_album(albums)
    length = albums.length
    choice = read_integer_in_range("Enter album UID:", 1, length) - 1
    album = albums[choice]
    track_id = play_tracks(album)

    return choice, track_id, album
end

def play_tracks(album)
  i = 0
  while (i < album.tracks.length)
    puts "Track number: #{(i+1).to_s}"
    puts album.tracks[i].name
    puts album.tracks[i].location
    i += 1
  end
  number = read_integer("Enter track number:")
  number = number - 1
  play_track(album, album.tracks[number])
  return number
end

def play_track(album, track)
  puts ("Now Playing:")
  puts track.name
  puts ("From album: #{album.title}")
  @song = Gosu::Song.new(track.location)
  @song.play(false)
end

#Main Menu Option 4: Update Album
def update_albums(albums)
  puts ("Update Album")
  puts ("------------")
  i = 0
  while (i < albums.length)
    display_album(albums[i], i)
    i += 1
  end
  choice = read_integer("Enter Album UID: ")
  update_album(albums, choice)
end

def update_album(albums, choice)
  display_album(albums[choice-1], choice-1)
  finished = false
  begin
    puts ("1 - Change title")
    puts ("2 - Change genre")
    puts ("3 - Back")
    number = read_integer_in_range("Select an option: ", 1, 3)
    case number
    when 1
      update_title(albums, choice)
      gets()
    when 2
      update_genre(albums, choice)
      gets()
    when 3
      finished = true
    else
      puts("Invalid selection")
    end
  end until finished
end

def update_title(albums, i)
  i = i - 1
  new = read_string("Enter new title:")
  albums[i].title = new
  puts("\nDone. Press ENTER to continue")
end

def update_genre(albums, i)
  i = i - 1
  puts ("1 - Pop")
  puts ("2 - Classic")
  puts ("3 - Jazz")
  puts ("4 - Rock")
  new = read_integer("Enter new genre by number:")
  albums[i].genre = new
  puts("\nDone. Press ENTER to continue")
end

def main()
  finished = false
  begin
    puts('Main Menu:')
    puts('1 - To Read in Album')
    puts('2 - To Display Album')
  	puts('3 - To Play Album')
    puts('4 - To Update an Album')
  	puts('5 - Exit')

    choice = read_integer_in_range("Please enter your choice:", 1, 5)
    case choice
      when 1
       albums = read_albums()
      gets()
    	when 2
      display_albums(albums)
    	when 3
      play_album(albums)
    	when 4
    	update_albums(albums)
      when 5
      finished = true
    else
      puts("Invalid selection")
    end
  end until finished
end

main()
