# Character Stuff
def get_backgrounds
  bckgrnds = {
    :ander_survivor => {
      :is_mage => false,
      :ability_bonus => -> { add_to_ability(:constitution, 1) },
      :focus_bonus => {
        :constitution_stamina => -> { add_focus(:constitution, "Stamina") },
        :strength_climbing => -> { add_focus(:strength, "Climbing") },
      },
      :languages_read => ["Ander", "Trade Tongue"],
      :languages_speak => ["Ander", "Trade Tongue"],
      :table => {
        "2" => -> { add_to_ability(:dexterity, 1) },
        "4" => -> { add_focus(:constitution, "Running") },
        "5" => -> { add_focus(:cunning, "Historical Lore") },
        "6" => -> { add_focus(:perception, "Tracking") },
        "8" => -> { add_to_ability(:strength, 1) },
        "9" => -> { add_focus(:dexterity, "Brawling") },
        "11" => -> { add_focus(:willpower, "Courage") },
        "12" => -> { add_to_ability(:perception, 1) },
      },
    },
    :antivian_wayfarer => {
      :is_mage => false,
      :ability_bonus => -> { add_to_ability(:communication, 1) },
      :focus_bonus => {
        :communication_bargaining => -> { add_to_ability(:communication, "Bargaining") },
        :cunning_navigation => -> { add_focus(:cunning, "Navigation") },
      },
      :languages_read => ["Antivian", "Trade Tongue"],
      :languages_speak => ["Antivian", "Trade Tongue"],
      :table => {
        "2"  => -> { add_to_ability(:cunning, 1) },
        "4"  => -> { add_focus(:cunning, "Evaluation") },
        "5"  => -> { add_focus(:communication, "Seduction") },
        "6"  => -> { add_focus(:communication, "Persuation") },
        "8"  => -> { add_to_ability(:dexterity, 1) },
        "9"  => -> { add_focus(:dexterity, "Initiative") },
        "11" => -> { add_focus(:perception, "Hearing") },
        "12" => -> { add_to_ability(:perception, 1) },
      },
    },
    elf_apostate: {
       is_mage: true,
       ability_bonus: -> { add_to_ability(:willpower, 1) },
       focus_bonus: {
         cunning_natural_lore: -> { add_focus(:cunning, "Natural Lore") },
         willpower_self_dicipline: -> { add_focus(:willpower, "Self-Discipline")}
       },
       languages_read: ["Trade Tongue"],
       languages_speak: ["Trade Tongue"],
       table: {
         "2"  => -> { add_to_ability(:cunning, 1) },
         "4"  => -> { add_language("Elven") },
         "5"  => -> { add_focus(:cunning, "Cultural Lore") },
         "6"  => -> { add_focus(:willpower, "Self-Discipline") },
         "8"  => -> { add_to_ability(:magic, 1) },
         "9"  => -> { add_focus(:dexterity, "Stealth") },
         "11" => -> { add_to_ability(:dexterity, 1) },
         "12" => -> { add_weapongroup("Bows")}
       }
    },
  }

  return bckgrnds
end

def get_talents
  talents = [
    {
      :name => "Archery Style",
      :requirements => {
        "weapon_groups" => ["Bows"],
        "class" => ["Warrior", "Rogue"],
      },
    },
    {
      :name => "Armour Training",
      :requirements => {
        "class" => ["Warrior"],
      },
    },
    {
      :name => "Chirurgy",
      :requirements => {
        "focus" => [:cunning, "Healing"],
      },
    },
    {
      :name => "Contacts",
      :requirements => {
        "abilities" => [:communication, 1],
      },
    },
    {
      :name => "Dual Weapon Style",
      :requirements => {
        "abilities" => [:cunning, 2],
        "class" => ["Warrior", "Rogue"],
      },
    },
    {
      :name => "Linguistics",
      :requirements => {
        "abilities" => [:cunning, 1],
      },
    },
    {
      :name => "Lore",
      :requirements => {
        "abilities" => [:cunning, 2],
      },
    },
    {
      :name => "Scouting",
      :requirements => {
        "abilities" => [:dexterity, 2],
        "class" => ["Rogue"],
      },
    },
    {
      :name => "Single Weapon Style",
      :requirements => {
        "abilities" => [:perception, 2],
        "class" => ["Warrior", "Rogue"],
      },
    },
    {
      :name => "Thievery",
      :requirements => {
        "abilities" => [:dexterity, 3],
        "class" => ["Rogue"],
      },
    },
    {
      :name => "Throwing Weapon",
      :requirements => {
        "weapon_groups" => ["Axes", "Spears", "Light Blades"],
        "class" => ["Warrior", "Rogue"],
      },
    },
    {
      :name => "Two-Hander Style",
      :requirements => {
        "abilities" => [:strength, 3],
        "weapon_groups" => ["Axes", "Heavy Blades", "Bludgeons", "Spears"],
        "class" => ["Warrior"],
      },
    },
    {
      :name => "Weapon & Shield Style",
      :requirements => {
        "abilities" => [:strength, 2],
        "class" => ["Warrior"],
      },
    },
  ]

  return talents
end

def get_focus
  # arrays with possible ability focus
  focus =
    {
      :communication => [
        "Animal Handling", "Bargaining", "Deception", "Disguise", "Etiquette", "Gambling", "Investigation", "Leadership", "Performance", "Persuation", "Seduction",
      ],
      :constitution => [
        "Drinking", "Rowing", "Running", "Stamina", "Swimming",
      ],
      :cunning => [
        "Arcane Lore", "Brewing", "Cartography", "Cultural Lore", "Enchantment", "Engineering", "Evaluation", "Healing", "Heraldry", "Historical Lore", "Military Lore", "Musical Lore", "Natural Lore", "Navigation", "Poison Lore", "Qun", "Research", "Religious Lore", "Writing",
      ],
      :dexterity => [
        "Acrobatics", "Bows", "Brawling", "Calligraphy", "Crafting", "Dueling", "Grenades", "Initiative", "Legerdemain", "Light Blades", "Lock Picking", "Riding", "Staves", "Stealth", "Traps",
      ],
      :magic => [
        "Arcane Lance", "Blood", "Creation", "Entropy", "Pri,mal", "Spirit",
      ],
      :perception => [
        "Empathy", "Detect Darkspawn", "Hearing", "Searching", "Seeling", "Smelling", "Tracking",
      ],
      :strength => [
        "Axes", "Bludgeons", "Climbing", "Driving", "Heavy Blades", "Intimidation", "Jumping", "Lances", "Might", "Polearms", "Smithing", "Spears",
      ],
      :willpower => [
        "Courage", "Faith", "Morale", "Self-Disipline",
      ],
    }

  return focus
end

# Equipment
def get_weapons()
  weapons =
    [
      {
        :type => "Weapon",
        :name => "Fists",
        :value => 0,
        :weapon_group => "Brawling",
        :min_str => 0,
        :dmg => {
          :dices => 1,
          :bonus => 0,
        },
        :reach => 0,
        :is_ranged => false,
        :is_melee => true,
        :is_two_handed => true,
        :can_offhand => false,
      },
      {
        :type => "Weapon",
        :name => "Battleaxe",
        :value => 100,
        :weapon_group => "Axes",
        :min_str => 0,
        :dmg => {
          :dices => 2,
          :bonus => 2,
        },
        :reach => 0,
        :is_ranged => false,
        :is_melee => true,
        :is_two_handed => false,
        :can_offhand => false,
      },
      {
        :type => "Weapon",
        :name => "Spear",
        :value => 100,
        :weapon_group => "Spears",
        :min_str => 0,
        :dmg => {
          :dices => 3,
          :bonus => 0,
        },
        :reach => 1,
        :is_ranged => false,
        :is_melee => true,
        :is_two_handed => true,
        :can_offhand => false,
      },
      {
        :type => "Weapon",
        :name => "Longsword",
        :value => 100,
        :weapon_group => "Long Blades",
        :min_str => 0,
        :dmg => {
          :dices => 2,
          :bonus => 0,
        },
        :reach => 0,
        :is_ranged => false,
        :is_melee => true,
        :is_two_handed => true,
        :can_offhand => true,
      },
    ]

  return weapons
end

def get_shields
  shields =
    [
      {
        :type => "Shield",
        :name => "Small Shield",
        :value => 100,
        :size => 0,
        :bonus => 1,
      },
      {
        :type => "Shield",
        :name => "Medium Shield",
        :value => 250,
        :size => 1,
        :bonus => 2,
      },
      {
        :type => "Shield",
        :name => "Heavy Shield",
        :value => 500,
        :size => 2,
        :bonus => 3,
      },
    ]

  return shields
end

def get_armors
  armors =
    [
      {
        :type => "Armor",
        :name => "Leather Cuirass",
        :value => 100,
        :weight => 0,
        :rating => 3,
        :penalty => 1,
      },
      {
        :type => "Armor",
        :name => "Chainmail",
        :value => 250,
        :weight => 1,
        :rating => 4,
        :penalty => 2,
      },
      {
        :type => "Armor",
        :name => "Plate",
        :weight => 500,
        :rating => 5,
        :penalty => 3,
      },
    ]

  return armors
end
