module Chess
	class Player
		attr_reader :name, :type
		attr_accessor :pieces

		def initialize(name, type)
			@name, @type = name, type
			@pieces = []
		end
	end
end