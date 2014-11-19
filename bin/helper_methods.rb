
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