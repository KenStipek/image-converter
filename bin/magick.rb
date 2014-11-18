require 'rmagick'
require 'open-uri'

def do_magick(image, params)
  new_image = image
  params.each_pair do |key, value|
    puts "Doing #{key} with these options #{value}"
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
    # Add default params to params
    image = do_magick(image, params)
    image.to_blob
  else
    nil
    # 404 error
  end
end