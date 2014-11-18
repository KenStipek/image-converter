require 'rmagick'
require 'open-uri'

def do_magick(image, params)
  new_image = image
  params.each_pair do |key, value|
    puts "Performing #{key} with options: #{value == '~' ? 'DEFAULTS' : value.split(';').join(', ')}"
    if value != '~'
      new_image = new_image.send(key, *value.split(';').map {|v| from_string(v) })
    else 
      new_image = new_image.send(key)
    end 
  end
  new_image
end

def get_image(path)
  domain = ENV['SOURCE_DOMAIN'] || 'images'
  exts = ['.jpg', '.png', '.jpeg', '.gif']
  exts_rx = Regexp.new("\\#{exts.join('|\\')}", 'i')
  file = nil

  # Remove extension from path if it exists
  path = path[0..(path.index(exts_rx) - 1)] if path.index(exts_rx)

  exts.each do |ext|
    begin
      file = open "#{domain}/#{path}#{ext}"
    rescue
    end
    break if !file.nil?
  end
  file
end

def prepare_magick(image_path, params = {})
  image = Magick::ImageList.new
  if (image.from_blob(get_image(image_path).read))
    image = image.first
    image = do_magick(image, params)
    image.to_blob
  else
    nil
    # 404 error
  end
end

# Get image conversion paramaters from full path and return hash.
def image_magick_params(full_path)
  params = Hash.new
  params.merge!(pair_array_to_hash(DEFAULTS.split('/'))) unless DEFAULTS.empty?
  path_params = full_path.split("/#{SPLIT_CHAR}/")
  if path_params.count > 1
    params.merge!(pair_array_to_hash(path_params.first.split('/').reject(&:empty?)))
  end
  params
end


