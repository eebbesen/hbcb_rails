# gem install nokogiri

require 'open-uri'
require 'nokogiri'

BASE_URL = 'https://www.gov.mb.ca/chc/archives/hbca/biographical/'
START_LETTER = ARGV[0] || 'a'

def download_pdf(letter, file_uri)
  file_uri = file_uri.gsub(/\s/, '%20')
  return unless file_uri.match(/.pdf$/)
  return if File.exist?("./downloads/#{file_uri}")

  full_uri = "#{BASE_URL}#{letter}#{file_uri}"

  begin
    puts "getting #{full_uri}"
    if ENV['DRY_RUN']
      puts 'DRY RUN -- nothing will be downloaded'
    else
      download = open("#{full_uri}")
      IO.copy_stream(download, "./downloads/#{file_uri}")
    end
  rescue URI::InvalidURIError => uri_error
    puts uri_error
    puts "ERROR: didn't download #{full_uri}"
  end
end

(START_LETTER..'z').each do |letter|
  puts "***************** PROCESSING #{letter} *****************"
  begin
    doc = Nokogiri::HTML(open("#{BASE_URL}#{letter}.html"))
  rescue OpenURI::HTTPError => ou_error
    puts ou_error
    puts "ERROR: didn't find #{BASE_URL}#{letter}.html"
    next
  end

  # Due to inconsistent HTML, we do both conditions :(
  doc.css("a[target='_blank']").each do |anchor|
    download_pdf(letter, "#{anchor['href']}".match(/\/(.*)/)[0])
  end

  doc.css("li[class='blanks2'] a").each do |anchor|
    download_pdf(letter, "#{anchor['href']}".match(/\/(.*)/)[0])
  end
end
