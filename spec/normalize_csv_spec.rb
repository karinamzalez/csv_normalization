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
end 