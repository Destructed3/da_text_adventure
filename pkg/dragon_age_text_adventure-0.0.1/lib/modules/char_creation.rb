require './ressources/helper_dialogue.rb'
require './ressources/dice_engine.rb'
require './character/lists.rb'
require './character/hero.rb'

#Class with funcitons to manipulate character stats
class CC # -> character-manipulation newCharCreation?
  include Dice_engine, HelpFunctions_dialoge

  def initialize
    @hero = Hero.new
    @abs = {
      :communication => [0, []],
      :constitution => [0, []],
      :cunning => [0, []],
      :dexterity => [0, []],
      :magic => [0, []],
      :perception => [0, []],
      :strength => [0, []],
      :willpower => [0, []],
    }
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
    @abs.keys.each do |key|
      @abs[key][0] = determine_ability_value(key)
    end

    puts ""
    puts "Your rolled these Abilities:"
    puts "Com|Con|Cun|Dex|Mag|Per|Str|Wil"
    @abs.each do |key, value|
      ending = (key != :willpower) ? " |" : ""
      print " " + value[0].to_s + ending
    end
    2.times { puts "" }

    @hero.abilities = @abs
  end

  def choose_background()
    puts "Background Benefits:"
    chosen_bkgr = ""

    loop do
      chosen_bkgr = inputloop_hash( "Available Backgrounds", get_backgrounds() )
      break if !chosen_bkgr[:is_mage]
      
      puts "Choosing this background will determine your character class to being a mage."
      if get_yes("Do you want to continue?")
        @hero.cclass = :mage
        break
      end
    end
    
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
    @abs.each do |key, value|
      puts key.to_s.capitalize + " " + value[0].to_s
      @abs[key][1].each do |focus|
        puts " -" + focus
      end
    end
    puts ""
  end

  def choose_class()
    # Choose char class    
    @hero.cclass = inputloop_array("Choose your Character Class!", ["Warrior", "Rogue"]) if @hero.cclass == nil
    @hero.lvlup
  end

  def conclusion()
    @hero.name = inputloop_text "Choose a Name!"
    puts ""
    @hero.print_charsheet
    add_weapons @hero
    @hero.open_inventory
    puts ""
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

  def add_weapons(hero)
    print hero.weapon_groups
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
