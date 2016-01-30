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
      parser = Parser.new(filename)
      parser.parse
      processed_count += 1
  end
  puts processed_count
end
