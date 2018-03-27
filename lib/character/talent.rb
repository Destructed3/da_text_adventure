class Talent
  attr_reader :name
  attr_reader :requirements     # Array([[ability_level,ability_focus],...],[wg1, wg2,...]])

  def initialize(name, req)
    @name = name
    @requirements = req
  end

  def test_compliance_of(hero)
    # test if hero allready has talent on master-level
    if (hero.talents.key? @name)
      return false if hero.talents[@name] == "Master"
    end
    
    # test if hero's class is allowed to learn this talent
    if @requirements.key? "class"
      return false if !@requirements["class"].include?(hero.cclass)
    end
    
    # test if hero abilities fit
    if @requirements.key?("abilities")
      x = @requirements["abilities"]
      return false if hero.abilities[x[0]][0] < x[1]
    end
    
    # check if hero has a necessary talent
    if @requirements.key? "focus"
      abort = false
      @requirements["focus"].each do |foc|
        if hero.abilities[foc[0]][1].include? foc[1]
          abort = true
          break
        end
      end
      return false if abort
    end
    
    # check if hero has necessary weapon groups
    if @requirements.key?("weapon_groups")
      @requirements["weapon_groups"].each do |requirement| 
        return true if hero.weapon_groups.include?( requirement )
      end
      return false
    end
    return true
  end
end
