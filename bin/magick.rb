require 'rmagick'
require 'open-uri'

def do_magick(image, params)
  new_image = image
  puts '### CONVERTING ###' if DEBUG
  begin
    params.each_pair do |key, value|
      if WHITELIST.include?(key)
        puts "Performing #{key} with options: #{value == '~' ? 'DEFAULTS' : value.split(';').join(', ')}" if DEBUG
        if value != '~'
          new_image = new_image.send(key, *value.split(';').map {|v| from_string(v) })
        else 
          new_image = new_image.send(key)
        end
      end
    end
  rescue
    puts $!.inspect, $@
    return false #404
  end
  puts '##################' if DEBUG
  new_image
end

def get_extension(path)
  image_exts = path.scan(Regexp.new("\\#{EXTS.join('|\\')}", 'i'))
  if image_exts.any?
    image_exts.last.to_s[1..-1]
  else
    false #404
  end
end

def get_image(path)
  domain = ENV['SOURCE_DOMAIN'] || 'images'
  exts_rx = Regexp.new("\\#{EXTS.join('|\\')}", 'i')
  file = nil

  # Remove extension from path if it exists
  path = path[0..(path.index(exts_rx) - 1)] if path.index(exts_rx)

  EXTS.each do |ext|
    begin
      file = open "#{domain}/#{path}#{ext}"
    rescue
      # Do nothing and try the image using the next extension.
    end
    break if !file.nil?
  end

  if !!file
    file
  else
    false
  end
end

def prepare_magick(image_path, ext, params = {})
  image = Magick::ImageList.new
  begin
    image.from_blob(get_image(image_path).read)
  rescue
    puts $!.inspect, $@
    return false #404
  end

  image = image.first
  identify_image image if DEBUG
  if !(image = do_magick(image, params))
    return false
  else
    image.format = ext.upcase
    identify_image image if DEBUG
    image.to_blob
    end
end

# Get image conversion paramaters from full path and return hash.
def image_magick_params(full_path)
  params = Hash.new

  begin
    # Add default paramaters if any and allowed.
    if !DEFAULTS.nil? and USE_DEFAULTS
      params.merge!(pair_array_to_hash(DEFAULTS.split('/')))
    end

    # Add path params if there are any and allowed.
    if USE_PARAMS
      path_params = full_path.split("/#{SPLIT_CHAR}/")
      if path_params.count > 1
        params.merge!(pair_array_to_hash(path_params.first.split('/').reject(&:empty?)))
      end
    end

    # Add template if requested and allowed
    if !params[TEMPLATE_MARK].nil? and USE_TEMPLATES
      templates = TEMPLATES.split('&')
      template_params = templates[templates.index(params[TEMPLATE_MARK]) + 1]
      params.merge!(pair_array_to_hash(template_params.split('/')))
      params.delete(TEMPLATE_MARK)
    end
  rescue
    # Load 404 on bad provided paramaters.
    puts $!.inspect, $@
    return false #404
  end
  params
end

# Extract just the image path from the full path.
def image_path(full_path)
  if full_path.index("/#{SPLIT_CHAR}/")
    image_path = full_path.split("/#{SPLIT_CHAR}/")

    if image_path.length >= 2
      image_path.last
    else
      false
    end
  else
    full_path
  end
end

def identify_image(img)
  puts '### IMAGE INFO ###'
  puts "Format: #{img.format}"
  puts "Geometry: #{img.columns}x#{img.rows}"
  puts "Depth: #{img.depth} bits-per-pixel"
  puts "Colors: #{img.number_colors}"
  puts "Filesize: #{img.filesize}"
  puts '##################'
end

