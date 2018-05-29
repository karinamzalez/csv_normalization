require 'pry'
require 'csv'
require 'date'
require 'time'
require 'active_support/all'

class NormalizeCsv
    attr_reader :csv_path 

    def initialize(stdin = './sample.csv', stdin2 = nil)
        @csv_path = stdin
        @output_path = stdin2 
    end 

    def run()
        output = []
        CSV.foreach(@csv_path || './sample.csv', headers: true, header_converters: :symbol, encoding: Encoding::UTF_8) do |row|
            raise "Deleting row #{row} due to invalid data" unless row.to_s.valid_encoding?
            row[:timestamp] = handleTimestamp(row[:timestamp])  
            row[:zip] = handleZip(row[:zip])
            row[:fullname] = handleName(row[:fullname])
            row[:fooduration] = handleDuration(row[:fooduration])
            row[:barduration] = handleDuration(row[:barduration])
            row[:totalduration] = row[:fooduration] + row[:barduration]
            row[:notes] = row[:notes]
            output << row
            rescue => e
                STDERR.puts e
        end
        write_csv(output)
    end

    def handleTimestamp(timestamp)
        eastern_time = convert_pacific_to_eastern(timestamp)
        eastern_time.iso8601
    end

    def handleZip(zip)
        if zip.length != 5 
            then newZip = zip.length < 5 ? zip.rjust(5,"0")[0..4] : zip[0..4]
        end
        newZip ||= zip 
    end

    def handleName(name)
        name.mb_chars.upcase.to_s
    end 

    def handleDuration(time)
        parsed_time = Time.parse(time)
        "%10.3f" % parsed_time.to_f 
    end 

    private 

    def write_csv(rows) 
        io = @output_path ? File.open(@output_path, 'w+') : $stdout.dup
        CSV(io) do |csv|
            rows.each do |row|
                csv << row
            end
        end
        ensure
        io.close
    end 

    def convert_pacific_to_eastern(time)
        parsed_time = DateTime.strptime(time + " PST", '%m/%d/%y %H:%M:%S %z')
        # convert from pacific (-08:00), to eastern (-05:00) = (+03:00)
        eastern_time = parsed_time.new_offset('+03:00')
        # update timezone acronym to reflect converted time 
        eastern_time = eastern_time.strftime('%Y/%m/%d %H:%M:%S')
        DateTime.parse(eastern_time + ' EST')
    end
    
end