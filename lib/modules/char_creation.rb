require './ressources/helper_dialogue.rb'
require './ressources/dice_engine.rb'
require './character/lists.rb'
require './character/hero.rb'

#Class with funcitons to manipulate character stats
class CC # -> character-manipulation newCharCreation?
  include Dice_engine, HelpFunctions_dialoge

  def initialize
    @hero = Hero.new
  end

  def new_character
    get_abilitys()
    choose_background()
    choose_class()
    conclusion()
    return @hero
  end

  :private

  def get_abilitys()
    @hero.abilities.keys.each do |key|
      @hero.abilities[key][0] = determine_ability_value(key)
    end

    puts ""
    puts "Your rolled these Abilities:"
    puts "Com|Con|Cun|Dex|Mag|Per|Str|Wil"
    @hero.abilities.each do |key, value|
      ending = (key != :willpower) ? " |" : ""
      print " " + value[0].to_s + ending
    end
    2.times { puts "" }

  end

  def choose_background()
    loop_out = Proc.new { |hash, key|
      if hash[key][:is_mage]
        get_yes("Chosing this background will render you a Mage.\nDo you wish to continue?")
      else
        get_yes("Do you wish to continue?")
      end
    }    
    
    puts "Background Benefits:"

    chosen_bkgr = inputloop_hash( "Available Backgrounds", get_backgrounds(), loop_out )
    
    @hero.cclass = "Mage" if chosen_bkgr[:is_mage]
    
    chosen_bkgr[:ability_bonus].()
    
    chosen_bkgr[:languages_read].each do |language|
      @hero.languages_read << language
    end
    chosen_bkgr[:languages_speak].each do |language|
      @hero.languages_speak << language
    end

    chosen_focus = inputloop_hash("Background Focus:", chosen_bkgr[:focus_bonus])
    chosen_focus.()

    puts "Benefits rolled on Background-Table:"
    get_benefits(chosen_bkgr[:table]).each do |benefit|
      benefit.()
    end

    #Conclusion for player
    puts "Final Values:"
    @hero.abilities.each do |key, value|
      puts key.to_s.capitalize + " " + value[0].to_s
      @hero.abilities[key][1].each do |focus|
        puts " -" + focus
      end
    end
    puts ""
  end

  def choose_class()    
    @hero.cclass = inputloop_array("Choose your Character Class!", ["Warrior", "Rogue"]) if @hero.cclass == nil
    @hero.lvlup
  end

  def conclusion()
    add_equipment(@hero)
    @hero.name = inputloop_text "Choose a Name!"
    @hero.print_charsheet
    @hero.open_inventory
    puts "Onto the Adventure!"
  end

  # Roll abilities
  def determine_ability_value(key)
    puts "Rolling " + key.to_s.capitalize
    r = roll false
    if r[0] < 4
      return -2
    elsif r[0] < 6
      return -1
    elsif r[0] < 9
      return 0
    elsif r[0] < 12
      return 1
    elsif r[0] < 15
      return 2
    elsif r[0] < 18
      return 3
    end
    return 4
  end

  def get_benefits(table)
    benefits = []

    while benefits.length < 2
      rolled_benefit = get_benefit(table)
      benefits << rolled_benefit if !benefits.include?(rolled_benefit)
    end

    return benefits
  end

  def get_benefit(table)
    roll = 0
    2.times { roll += 1 + rand(6) }

    table.keys.each do |key|
      return table[key] if roll <= Integer(key)
    end
  end

  def add_equipment(hero)
    weapons = get_weapons()
    hero.inventory[:backpack] << weapons.find { |we| we[:name] == "Fists" }
    if hero.weapon_groups.include? "Spears"
      hero.inventory[:backpack] << weapons.find { |we| we[:name] == "Spear" }
    end
    if hero.weapon_groups.include? "Axes"
      hero.inventory[:backpack] << weapons.find { |we| we[:name] == "Battleaxe" }
    end
    if hero.weapon_groups.include? "Long Blades"
      hero.inventory[:backpack] << weapons.find { |we| we[:name] == "Longsword" }
    end
  end

  def add_focus(ability, focus)
    puts "Adding " + focus + "-Focus to " + ability.to_s.capitalize
    @hero.abilities[ability][1] << focus
  end

  def add_to_ability(ability, value)
    puts "Adding +" + value.to_s + " to " + ability.to_s.capitalize
    @hero.abilities[ability][0] += value
  end

  def add_to_trait(trait, value)
    puts "Adding #{value} to #{trait.to_s}"
    @hero.trait << value
  end
  
  def add_weapongroup(weapon_group)
    puts "Adding weapon group " + weapon_group
    @hero.weapon_groups << weapon_group
  end
  
  def add_language( language )
    puts "Adding language #{language}"
    @hero.languages_speak << language
  end
  
  def add_language_read( language )
    puts "Adding language #{language}"
    @hero.languages_read << language
  end
  
  def add_language_speak( language )
    puts "Adding language #{language}"
    @hero.languages_read << language
  end
  
end
