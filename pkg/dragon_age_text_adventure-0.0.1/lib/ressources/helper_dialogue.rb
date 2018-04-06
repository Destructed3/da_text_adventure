module HelpFunctions_dialoge
  # convert input into boolean
  # get strings functions
  def inputlist_numbers
    return [
      ["0", "zero", "null"],
      ["1","one","eins"],
      ["2","two","zwei"],
      ["3","drei","three"],
      ["4","vier","four"],
      ["5","fünf","five"],
      ["6", "sechs", "six"],
      ["7", "sieben", "seven"],
      ["8", "acht", "eight"],
      ["9", "neun", "nine"],
    ]
  end
  
  def inputlist_yes
    return ["yes", "y", "1", "okay"]
  end
  
  def inputlist_close
    return ["quit", "close", "exit", "go away", "fuck you"]
  end
  
  # basic functions
  def compare_to_2d_array( input, arr = inputlist_numbers() ) 
    arr.each do |li|
      return true if li.include?(input)
    end
    
    return false
  end

  def convert_string_to_number ( input, arr = inputlist_numbers() )
    arr.length.times do |i| 
      return i if arr[i].include?( input )
    end
    
    return false
  end
  
  def get_yes( question )
    return inputlist_yes().include?( get_input( question ) )
  end
  
  def get_input( question )
    puts question
    print "> "
    answer = gets
    answer.chomp!
    puts ""
    return answer
  end
  
  def inputloop_text ( header )
    loop do
      pInput = get_input( header )
      puts "You choose the name #{pInput}."
      return pInput if get_yes( "Continue?" )
    end
  end
  
  def get_output_array(input, array)
    puts input
    return input if array.include?(input)
    
    nr = convert_string_to_number( input )
    return array[ convert_string_to_number(nr) ] if nr < array.length
    
    return false
  end
  
  # default input loops
  def inputloop_array ( header, array, loop_out = nil )    
    loop_out = default_loop_out() if loop_out == nil
    
    loop do      
      output = nil
      puts header
      
      array.length.times do |i|
        puts (i+1).to_s + ". " + array[i].to_s
      end
      
      number = Integer(get_input( "Choose one!" )) - 1
      output = array[number]
      
      if output
        puts "You choose #{output.to_s}: #{number.to_s}"
        return output if loop_out.()
      else
        puts "Please choose a legal option!"
      end
      
    end
    
  end
  
  def inputloop_hash(header = "", hash  = {}, loop_out = nil)
    loop_out = default_loop_out() if loop_out == nil
    loop do
      puts header
  
      index = 1
      array = []
      hash.keys.each do |key|
        puts index.to_s + " - " + get_hash_title(key)
        array << key
        index += 1
      end
      
      input = number_or_false( get_input( "Please choose one!" ) )
      
      if(input && input - 1 <= hash.length)
        key = array[input - 1]
        puts "You have chosen " + get_hash_title(key)
        
        return hash[key] if(  loop_out.(hash, key) )
      end
    end
    
  end
  
  def inputloop_objects_list ( header, list )
    loop do
      output = nil
      
      puts header
      
      list.length.times do |i|
        puts (i+1).to_s+". "+list[i].name
      end
      
      pInput = get_input( "Choose one!" )
      pInput = pInput.downcase
      
      output = list.find{ |li| li.name == pInput }
      
      if(!( output === nil ))
        puts "You choose #{pInput}."
      elsif compare_to_2d_array( pInput )
        output = list[convert_string_to_number( pInput )]
        puts "You choose #{output.name}."
      else
        puts "Please choose a legal option!"
      end
      
      break if output != nil && get_yes( "Do you want to accept this choice?" )
    end
    
    return output
  end  
  
  def get_hash_title(title)
    parts = title.to_s.split('_')
    title = ""
    parts.each { |word| title += word.capitalize + " "}
    return title.chop
  end
  
  def number_or_false(string)
    return Integer(string || '')
  rescue ArgumentError
    return false
  end
  
  def default_loop_out
    return Proc.new { 
      get_yes( "Do you want to accept this choice?" ) 
    }
  end
  
end