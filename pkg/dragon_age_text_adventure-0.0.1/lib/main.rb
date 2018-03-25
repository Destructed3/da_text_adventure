require './modules/char_creation.rb'

class Start
  char_creation = CC.new
  hero = char_creation.new_character
end

Start.new
