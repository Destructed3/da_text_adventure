require 'ressources/helper_dialogue'

RSpec.describe HelpFunctions_dialoge do
    context "Helpers" do
        let(:dummy_class) { Class.new { extend HelpFunctions_dialoge } }

        it "converts strings to numbers" do
            10.times do |i|
                puts i
                expect(dummy_class.convert_string_to_number( i.to_s )).to eq i
            end            
        end

        it "gets input" do 
            dummy_class.stub(gets: 'test')
            expect(dummy_class.get_input('Test')).to eq 'test'
        end

        it "gets yes" do
            dummy_class.stub(gets: '1')
            expect(dummy_class.get_yes('1')).to eq true
            dummy_class.stub(gets: 'y')
            expect(dummy_class.get_yes('y')).to eq true
            dummy_class.stub(gets: 'yes')
            expect(dummy_class.get_yes('yes')).to eq true
            dummy_class.stub(gets: 'okay')
            expect(dummy_class.get_yes('okay')).to eq true
            dummy_class.stub(gets: 'nasdf')
            expect(dummy_class.get_yes('nasdf')).to eq false
        end

        it "get the right array output" do
            array = ["1", "2", "3"]
            expect(dummy_class.get_output_array("1", array)).to eq "1"
        end
    end
end