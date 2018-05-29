require './lib/normalize_csv'
require 'pry'
require 'csv'

describe NormalizeCsv do 
    let(:normalizeCsv) { described_class.new() }

    context 'setup' do 
        it 'it exists' do 
            expect(normalizeCsv).to be_a NormalizeCsv
        end 
    
        it 'uses sample csv file as default' do 
            expect(normalizeCsv.csv_path).to eq './sample.csv'
        end
        
        it 'takes in a csv path' do 
            #validate csv ? 
            testNormalizeCsv = described_class.new('./testing.csv')

            expect(testNormalizeCsv.csv_path).to eq './testing.csv'
        end
    end

    context 'Timestamp' do 
        it 'convert_pacific_to_eastern outputs eastern time ' do
            pacific_time = '4/1/11 11:00:00 AM'
            parsed_pacific = DateTime.parse("2011-04-01T11:00:00-05:00")
            eastern_time = normalizeCsv.handleTimestamp(pacific_time)
            parsed_eastern = DateTime.parse(eastern_time)
            
            expect(parsed_eastern.zone).to eq('-05:00')
            expect(parsed_eastern.hour).to eq(14)
            expect(parsed_pacific.hour - parsed_eastern.hour).to eq(-3)
        end

        it 'formats time into iso8601 format' do
            pacific_time = '4/1/11 11:00:00 AM'
            iso_formatted_time = normalizeCsv.handleTimestamp(pacific_time)
            
            expect(iso_formatted_time).to eq('2011-04-01T14:00:00-05:00')
        end

        it 'handles invalid dates' do 
            time = '3/12/14 12:00:00 AM'

            expect(normalizeCsv.handleTimestamp(time)).to eq('2014-03-12T15:00:00-05:00')
        end 
    end

    context('handleZip') do 
        it("it doesn't do anything if zip is 5 digits") do
            zip = '12345'

            expect(normalizeCsv.handleZip(zip)).to eq('12345')
            expect(normalizeCsv.handleZip(zip).length).to eq(5)
        end  

        it("it uses 0 as prefix for zips less than 5 digits") do
            zip = '12'

            expect(normalizeCsv.handleZip(zip)).to eq('00012')
            expect(normalizeCsv.handleZip(zip).length).to eq(5)
        end  
        
        it("it handles zips greater than 5 digits") do
            # specifically handles zip + 4 codes 
            zip = '12345+1234'

            expect(normalizeCsv.handleZip(zip)).to eq('12345')
            expect(normalizeCsv.handleZip(zip).length).to eq(5)
        end  
    end 

    context('handleName') do 
        it("it capitalizes name") do
            name = 'Monkey Alberto'

            expect(normalizeCsv.handleName(name)).to eq('MONKEY ALBERTO')
        end  
     
        it("it capitalizes letters with accents") do
            name = 'Résumé Ron'
            name2 = 'Superman übertan'

            expect(normalizeCsv.handleName(name)).to eq('RÉSUMÉ RON')
            expect(normalizeCsv.handleName(name2)).to eq('SUPERMAN ÜBERTAN')
        end  
    
        it("it capitalizes non-ASCII letters") do
            name = '株式会社スタジオジブリ'

            expect(normalizeCsv.handleName(name)).to eq('株式会社スタジオジブリ')
        end  
    end

    context('handleDuration') do 
        it("it converts time to floating point seconds format w/ 3 decimal places") do
            time = '1:23:32.123'

            expect(normalizeCsv.handleDuration(time)).to eq('1527578612.123')
        end  
        # it("handles hours out of range") do
        #     time = '31:23:32.123'

        #     expect(normalizeCsv.handleDuration(time)).to eq('MONKEY ALBERTO')
        # end  
    end 

    context('run') do 
        it("outputs normalized csv via standard output if file is specified") do
            output = normalizeCsv.run()
            first_row = [[
                            "2011-01-01T15:00:01-05:00", 
                            "This Is Not An Address, BusyTown, BT", 
                            "94121", 
                            "MARY 1", 
                            "1527578612.123", 
                            "1527573600.000", 
                            "1527578612.1231527573600.000", 
                            "I like Emoji! 🍏🍎😍"
                        ]]

            expect(CSV.parse(output[1].to_s)).to eq(first_row)
        end  
    end 
end 