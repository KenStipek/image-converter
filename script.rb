require 'sinatra'
require './bin/helper_methods'
require './bin/magick'
require './bin/magick_methods'

FILE_DOMAIN    = ENV['FILE_DOMAIN'] || false
USE_PARAMS     = ENV['USE_PARAMS'] || true
DEFAULTS       = ENV['DEFAULTS']
USE_DEFAULTS   = ENV['USE_DEFAULTS'] || true
TEMPLATES      = ENV['TEMPLATES']
USE_TEMPLATES  = ENV['USE_TEMPLATES'] || true
TEMPLATE_MARK  = ENV['TEMPLATE_MARK'] || 'template'
SPLIT_CHAR     = ENV['SPLIT_CHAR'] || '_'
WHITELIST      = ENV['WHITELIST'] ? ENV['WHITELIST'].split(',') : MAGICK_METHODS
DEBUG          = ENV['DEBUG'] || true

EXTS = ['.jpg', '.png', '.jpeg', '.gif']

get '/favicon.ico' do
end

get '/*' do
  halt(404) unless (ext = get_extension(request.fullpath))
	halt(404) unless (image_location = image_path(request.fullpath))
	halt(404) unless (magick_params = image_magick_params(request.fullpath))
  halt(404) unless (image = prepare_magick(image_location, ext, magick_params))

  content_type "image/#{ext}"
  image
end
