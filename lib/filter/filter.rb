module Filter
	def self.extract(str)
		str.gsub!(/\(.*\)/,'')
		str.gsub!(/\[.*\]/,'')
		str.gsub!(/\s+/,' ')
		str.strip!
		str
	end
end