
# Extract just the image path from the full path.
def image_path(full_path)
	image_path = ENV['SPLIT_CHAR'] || full_path.split('/_/')

	if image_path.length >= 2
		image_path.last
	else
		false
	end
end

# Get image conversion paramaters from full path and return hash.
def image_magick_params(full_path)
	params = ENV['SPLIT_CHAR'] || full_path.split('/_/')
	pair_array_to_hash params.first.split('/').reject(&:empty?)
end

def pair_array_to_hash(ary)
	if ary.length.odd?
		false
	else
		Hash[*ary]
	end
end

def prepend_http(domain)
	/http(s?):\/\//.match(domain) ? domain : "http://#{domain}"
end

def from_string(value)
	if value.to_i.to_s == value
		value.to_i
	elsif value.to_f.to_s == value
		value.to_f
	else
		value
	end
end