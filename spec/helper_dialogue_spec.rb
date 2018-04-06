require 'ressources/helper_dialogue'

RSpec.describe HelpFunctions_dialoge do
  let(:dummy_class) { Class.new { extend HelpFunctions_dialoge } }
  context "convert_string_to_number" do      

    it "converts lettery numbers to numbers" do
      arr = ["one", "two", "three", "four", "fünf", "sechs", "sieben","acht","nine","zero"]
      arr.each do |word|
        expect(dummy_class.convert_string_to_number( word )).to be_truthy
      end
    end
    
    it "converts strings of numbers to numbers" do
      10.times do |i|
          expect(dummy_class.convert_string_to_number( i.to_s )).to eq i
      end
      expect(dummy_class.convert_string_to_number( "11" )).to eq false
    end     
      
  end

  context "get_input" do
    it "gets a string and returns it" do 
      allow(dummy_class).to receive(:gets).and_return("test")
      expect(dummy_class.get_input('test')).to eq 'test'
    end
  end

  context "get_yes" do
    it "gets yes" do
      ["1", "y", "yes", "okay"].each do |str|
        allow(dummy_class).to receive(:gets).and_return(str)
        expect(dummy_class.get_yes("Testing #{str}")).to be true
      end
    end
    
    it "gets no" do
      allow(dummy_class).to receive(:gets).and_return('no')
      expect(dummy_class.get_yes("Testing no")).to be false
    end
  end 

  context "get_output_array" do
    it "returns a string" do
      array = ["1", "2", "3"]
      array.each do |str|
        expect(dummy_class.get_output_array(str, array)).to be str
      end      
    end
    
    it "returns the correct item" do
      array = [0, 1, 2, 3]
      array.each do |item|
        expect(dummy_class.get_output_array(item, array)).to eq array[item]
      end
    end
    
  end  
  
  context "inputloop_array" do    
    array = [
      {a: 1, b: 2, c: 3}, 
      "Hallo", 
      1, 
      2, 
      3, 
      -> { dummy_class.() }
    ]
    
    it "returns the correct item" do
      test_inputloop_collection( :inputloop_array, array )
    end
    
  end
  
  context "inputloop_hash" do
    hash = {
      a: 1, 
      b: "2", 
      c: [1,2,3], 
      d: {a: 1, b: 2, c: 3}, 
      e: -> { dummy_class.() } 
    }
    
    it "returns correct item" do
      test_inputloop_collection( :inputloop_hash, hash )
    end
    
  end
end

def test_inputloop_collection( function, collection )
  expect(collection.respond_to?(:each)).to eq true
  i = 1
  collection.each do |v1, v2|
    item = v2 || v1
    allow(dummy_class).to receive(:gets).and_return( i.to_s, "1" )
    expect( dummy_class.send( function, "Test", collection ) ).to be item
    i += 1
  end
end
