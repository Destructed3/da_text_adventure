module Dice_engine
  def roll(crit = true)
    result = get_dice_rolls()
    print "The dices show: " + result[:rolls].to_s + " -> " + result[:values][0].to_s
    puts ""

    result = get_crit(result, crit)
    if (result[:values][1] > 0)
      print "A Stunt happenes!"
      print "#{result[:values][1]} stunt-points are generated."
      puts ""
    end

    return result[:values]
  end

  def get_dice_rolls()
    result = {
      :rolls => [0, 0, 0],
      :values => [0, 0],      # value of roll | generated crit-points
    }

    3.times { |i|
      roll = 1 + rand(6)
      result[:values][0] += roll
      result[:rolls][i] = roll
    }

    return result
  end

  def get_crit(result, crit)
    if ((result[:rolls][0] == result[:rolls][1] ||
         result[:rolls][0] == result[:rolls][2] ||
         result[:rolls][1] == result[:rolls][2]) &&
        crit)
      result[:values][1] = result[:rolls][1]
    end

    return result
  end
end
