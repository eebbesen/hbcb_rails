# require File.expand_path('../../app/controllers/parser.rb', __FILE__)
# require 'byebug'

desc "Slurp text files into database"
task :slurp, [:f] => [:environment] do |t, args|
  Bio.destroy_all
  Posting.destroy_all
  processed_count = 0
  filenames = if !args[:f].blank?
                [args[:f].strip]
              else
                Dir.glob(File.expand_path('../../../data/converted/*.txt', __FILE__))
              end
  filenames.each do |filename|
    puts "Processing #{filename}"
    # begin
      parser = Parser.new(filename)
      parser.parse
      processed_count += 1
    # rescue => error
    #   puts "Error parsing #{filename}"
    #   puts error
    # end
  end
  puts processed_count
end