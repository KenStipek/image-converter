require 'sinatra'
require './bin/helper_methods'
require './bin/magick'

DEFAULTS      = ENV['DEFAULTS']
TEMPLATES     = ENV['TEMPLATES']
TEMPLATE_MARK = ENV['TEMPLATE_MARK'] || 'template'
SPLIT_CHAR    = ENV['SPLIT_CHAR'] || '_'

get '/favicon.ico' do
end

get '/*' do
  # content_type "image/#{request.fullpath[path.index(/|\.jpg|\.png|\.jpeg|\.gif/i)..-1]}"
  # puts request.fullpath[request.fullpath.index(/|\.jpg|\.png|\.jpeg|\.gif/i)..-1]
  # puts request.fullpath.index(/|\.jpg|\.png|\.jpeg|\.gif/i)
  # puts request.fullpath.to_s.index(/|\.jpg|\.png|\.jpeg|\.gif/i)
  content_type "image/jpg"
	image_location = image_path request.fullpath
	magick_params = image_magick_params request.fullpath
  prepare_magick image_location, magick_params
end
