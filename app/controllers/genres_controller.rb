class GenresController < ApplicationController
  
  def show
    params[:id] ||= Genre.first.id
    @genre = Genre.find params[:id]
    @tracks = Track.paginate :per_page => 20, :page => params[:page], :conditions => {:genre_id => @genre.id}
    @track_names = @tracks.collect { |track|
      "#{track.artists.collect(&:name).join(', ')} - #{track.name} (#{track.mix_name})"
    }
  end
end
