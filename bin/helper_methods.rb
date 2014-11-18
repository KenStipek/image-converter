
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