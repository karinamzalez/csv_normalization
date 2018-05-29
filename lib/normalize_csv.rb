require 'pry'
require 'csv'
require 'date'

class NormalizeCsv
    attr_reader :csv_path 

    def initialize(stdin = './sample.csv')
        @csv_path = stdin
    end 

    def handleTimestamp(timestamp)
        eastern_time = convert_pacific_to_eastern(timestamp)
        eastern_time.iso8601
    end

    private 

    def convert_pacific_to_eastern(time)
        parsed_time = DateTime.strptime(time + " PST", '%m/%d/%y %H:%M:%S %z')
        # convert from pacific (-08:00), to eastern (-05:00) = (+03:00)
        eastern_time = parsed_time.new_offset('+03:00')
        # update timezone acronym to reflect converted time 
        eastern_time = eastern_time.strftime('%Y/%m/%d %H:%M:%S')
        DateTime.parse(eastern_time + ' EST')
    end
    
end