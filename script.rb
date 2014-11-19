require 'sinatra'
require './bin/helper_methods'
require './bin/magick'
require './bin/magick_methods'

DEFAULTS      = ENV['DEFAULTS']
TEMPLATES     = ENV['TEMPLATES']
TEMPLATE_MARK = ENV['TEMPLATE_MARK'] || 'template'
SPLIT_CHAR    = ENV['SPLIT_CHAR'] || '_'
WHITELIST     = ENV['WHITELIST'] ? ENV['WHITELIST'].split(',') : MAGICK_METHODS

get '/favicon.ico' do
end

get '/*' do
  ext = get_extension request.fullpath
  content_type "image/#{ext}"
	image_location = image_path request.fullpath
	magick_params = image_magick_params request.fullpath
  prepare_magick image_location, magick_params
end
