require './lib/normalize_csv'
require 'pry'

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
    end
end 