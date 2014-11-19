require 'sinatra'
require './bin/helper_methods'
require './bin/magick'
require './bin/magick_methods'

DEFAULTS      = ENV['DEFAULTS']
TEMPLATES     = ENV['TEMPLATES']
TEMPLATE_MARK = ENV['TEMPLATE_MARK'] || 'template'
SPLIT_CHAR    = ENV['SPLIT_CHAR'] || '_'
WHITELIST     = ENV['WHITELIST'] ? ENV['WHITELIST'].split(',') : MAGICK_METHODS
DEBUG         = ENV['DEBUG'] || true

EXTS = ['.jpg', '.png', '.jpeg', '.gif']

get '/favicon.ico' do
end

get '/*' do
  ext = get_extension request.fullpath
	image_location = image_path request.fullpath
	magick_params = image_magick_params request.fullpath
  image = prepare_magick(image_location, ext, magick_params)

  content_type "image/#{ext}"
  image
end
