# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'ressources/dice_engine'

def test_int( value, min, max )
  expect(value).is_a?(Integer)
  expect(value >= min).to eq true
  expect(value <= max).to eq true
end

RSpec.describe Dice_engine do
  let(:dummy_class) { Class.new { extend Dice_engine } }
  context "get_dice_rolls" do
    it "get_dice_rolls()" do
      10.times do
        roll = dummy_class.get_dice_rolls()
        expect(roll).respond_to?(:keys)
        expect(roll.keys.length).to eq 2 
        expect(roll.keys.include?(:values)).to eq true
        expect(roll[:values]).respond_to?(:length)
        expect(roll[:values].length).to eq 2
        test_int(roll[:values][0], 3, 18)
        expect(roll[:values][1]).to eq 0
        expect(roll.keys.include?(:rolls)).to eq true
        expect(roll[:rolls]).respond_to?(:length)
        expect(roll[:rolls].length).to eq 3
        roll[:rolls].each do |value|
          test_int(value, 1, 6)
        end
      end
    end
  end
  
  context "get_crit" do
    
    it "generates crit" do
      array = [
        {
          values: [3, 0],
          rolls: [1, 1, 1]
        },
        {
          values: [6, 0],
          rolls: [1, 2, 3]
        },
        {
          values: [4, 0],
          rolls: [1, 1, 2]
        },
        {
          values: [4, 0],
          rolls: [1, 2, 1]
        },
        {
          values: [4, 0],
          rolls: [2, 1, 1]
        },
      ]
      answers = [
        {
          values: [3, 1],
          rolls: [1, 1, 1]
        },
        {
          values: [6, 0],
          rolls: [1 , 2, 3]
        },
        {
          values: [4, 1],
          rolls: [1, 1, 2]
        },
        {
          values: [4, 2],
          rolls: [1, 2, 1]
        },
        {
          values: [4, 1],
          rolls: [2, 1, 1]
        },
      ]
      
      array.length.times do |i|
        expect(dummy_class.get_crit(array[i], false)).to be array[i]
        expect(dummy_class.get_crit(array[i], false)).to eq array[i]
        expect(dummy_class.get_crit(array[i], true)).to be array[i]
        expect(dummy_class.get_crit(array[i], true)).to eq answers[i]
      end
    end
    
  end
  
  context "roll" do
    
    it "returns the correct hash" do
      1000.times do
        r_false = dummy_class.roll(false)
        expect(r_false.length).to eq 2
        test_int(r_false[0], 3, 18)
        expect(r_false[1]).to eq 0
        
        r_true = dummy_class.roll(true)
        expect(r_true[1] > 0).to eq true if r_true[0] >= 16
      end
      
    end
    
  end
end
