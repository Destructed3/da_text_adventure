require './ressources/helper_dialogue.rb'
require './ressources/dice_engine.rb'
# require './character/talents.rb'
# require './character/equipment.rb'
class Hero
  include HelpFunctions_dialoge, Dice_engine
  #Meta-Attributes
  attr_accessor :name
  attr_accessor :cclass
  attr_accessor :speci            #Specialisation
  attr_accessor :is_GreyWarden
  attr_accessor :background
  attr_accessor :xp               # Array [xp / level]
  attr_accessor :hp               # Array [hp / max_hp]
  attr_accessor :mana             # Array [mana / max_mana]
  #Character-Traits
  attr_accessor :languages_speak
  attr_accessor :languages_read
  attr_accessor :abilities        # [[com,[com focuses]], [con,[con focuses]], ect...]
  attr_accessor :talents          # Stores Talents as hashes
  attr_reader :weapon_groups      # stores known weapon groups as an array
  attr_reader :inventory          # stores equipment as a hash {'mainhand' => weapon, 'offhand' => weapon, 'armour' => armour, 'trinkets' => [trinket1,ect], 'backpack' => []}
  #abgeleitete attribute
  def initialize
    @name = ""
    @cclass = nil
    @speci = nil
    @is_GreyWarden = false
    @background = nil
    @xp = [0, 0]
    @hp = [0, 0]
    @mana = [0, 0]
    @languages_speak = []
    @languages_read = []
    @weapon_groups = []
    @abilities = {
      :communication => [0, []],
      :constitution => [0, []],
      :cunning => [0, []],
      :dexterity => [0, []],
      :magic => [0, []],
      :perception => [0, []],
      :strength => [0, []],
      :willpower => [0, []]
    }
    @talents = {}
    @weapon_groups = []
    @inventory = { backpack: [] }
    @equipment_slots = [:mainhand, :offhand, :armour, :trinkets]
  end

  # Other Attributes
  def speed()
    return 10 + @abilities[:dexterity][0] - @speed_mod
  end

  def defence()
    return 10 + ability[:dexterity][0] + get_shield_bonus()
  end

  def get_shield_bonus()
    return @inventory["offhand"].type === "Shield" ? @inventory["offhand"].bonus : 0
  end

  def get_ini()
    ini = @abilities[:dexterity][0]
    3.times { ini += rollDice }
    return ini
  end

  # XP / Lvlup
  def add_xp(xp)
    @xp[0] += xp
    lvl_up() if is_lvl_up?
  end

  def is_lvl_up?
    lvlup_limit = 0
    @xp[1].times do |int|
      lvlup_limit += 2000 if int < 5
      lvlup_limit += 3000 if int >= 6 && int < 11
      lvlup_limit += 4000 if int >= 11
    end

    return lvlup_limit <= @xp[1]
  end

  def lvlup
    if @xp[1] < 1
      # base level
    else
      # normal level
    end
    
    @xp[1] += 1
  end

  def add_talent()
  end
  
  # inventory   
  def open_inventory
    loop do
      display_inventory()
      
      break if !manipulate_inventory()
    end
  end
  
  def display_inventory()
    puts "INVENTORY"
      puts "----------"
      
      @equipment_slots.each do |slot|
        show_equipment_slot(slot) 
      end
      
      show_equipment_slot(:backpack)
      
      puts "----------"
  end
  
  def manipulate_inventory()
    options = [
        "Change Mainhand",
        "Change Offhand",
        "Change Armour",
        "Change Trinket",
        "Close Inventory"
      ]

    input = inputloop_array("What do you want to do?", options)
      
    case (convert_string_to_number(input) + 1)
    when 1
      change_mainhand()
    when 2
      change_offhand()
    when 3
      change_armour()
    when 4
      change_trinkets()
    when 5
      return false
    end
  end
  
  def show_equipment_slot( slot )
    print slot.to_s.capitalize + ": "
    slot = @inventory[slot]
    if slot.respond_to?( name )
      puts slot.name
    elsif slot.respond_to?( :each )
      puts ""
      if slot.length > 0
        slot.each { |item| show_equipment_slot( item ) }
      else
        puts "empty"
      end
    else    
      puts "empty"
    end
  end

  def add_item(newItem)
    @inventory[backpack] << newItem
  end

  def remove_item(item)
    if (item.is_a?(Equip))
      item = @inventory[backpack].index(item)
    elsif (item.is_a?(String))
      item = Integer(item)
    end

    if (item.is_a?(Integer))
      return @inventory[backpack].delete_at(item)
    else
      return false
    end
  end

  def change_mainhand
    arr = []
    inventory["backpack"].each { |itm| arr << itm if itm.is_a?(Weapon) }
    if arr.length > 0
      inventory["mainhand"] = inputloop_objects_list "Equip which weapon?", arr
    else
      puts "You don't have a weapon to equip"; gets
    end
    inventory["offhand"] = nil if inventory["offhand"] != nil && inventory["offhand"].is_two_handed
    if inventory["mainhand"].is_two_handed
      inventory["offhand"] = inventory["mainhand"]
    end
    puts ""
    return true
  end

  def change_offhand
    arr = []
    inventory["backpack"].each { |itm| arr << itm if (itm.is_a?(Weapon) && itm.can_offhand) || itm.is_a?(Shield) }
    if arr.length > 0
      if inventory["mainhand"].is_two_handed
        puts "Changing the offhand weapon will unequip your two handed weapon. Continue?"
        if get_inputList_yes.include? gets[0...-1]
          inventory["offhand"] = inputloop_objects_list "Equip which item?", arr
          inventory["mainhand"] = nil
        end
      else
        inventory["offhand"] = inputloop_objects_list "Equip which item?", arr
      end
    else
      puts "No items to equip in offhand"
    end
  end

  def change_armour
    arr = []
    inventory["backpack"].each { |itm| arr << itm if itm.is_a?(Armour) }
    inventory["armour"] = inputloop_objects_list arr if arr.length > 0
  end

  def change_trinkets
    puts "???"
  end  

  # print Charscheet
  def print_charsheet
    puts @name
    puts @cclass
    puts @xp[0].to_s + " XP / Level " + @xp[1].to_s

    print_attributes()

    puts ""

    puts "Talents:"
    @talents.each do |key, value|
      puts key + ": " + value
    end
  end

  def print_attributes()
    puts "Com|Con|Cun|Dex|Mag|Per|Str|Wil"
    @abilities.each do |key, value|
      ending = (key != :willpower) ? " |" : ""
      print " " + value[0].to_s + ending
    end

    puts ""

    @abilities.each do |key, value|
      if (value[1].length > 0)
        puts "Focus " + key.to_s.capitalize
        foci = ""
        value[1].each do |focus|
          foci << focus + ", "
        end
        puts foci.chop.chop
        puts ""
      end
    end
  end
end
