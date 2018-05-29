require 'pry'
require 'csv'

class NormalizeCsv
    attr_reader :csv_path 

    def initialize(stdin = './sample.csv')
        @csv_path = stdin
    end 
end