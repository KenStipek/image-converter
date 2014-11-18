require 'sinatra'
require './bin/helper_methods'
require './bin/magick'

get '/*' do
  # content_type "image/#{request.fullpath[path.index(/|\.jpg|\.png|\.jpeg|\.gif/i)..-1]}"
  # puts request.fullpath[request.fullpath.index(/|\.jpg|\.png|\.jpeg|\.gif/i)..-1]
  # puts request.fullpath.index(/|\.jpg|\.png|\.jpeg|\.gif/i)
  puts request.fullpath.to_s.index(/|\.jpg|\.png|\.jpeg|\.gif/i)
	image_location = image_path request.fullpath
	magick_params = image_magick_params request.fullpath
  prepare_magick image_location, magick_params
end
