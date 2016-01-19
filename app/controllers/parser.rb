class Parser
  attr_reader :header_indexes, :bio

  def initialize(file)
    @file = file
  end

  def parse
    parse_bio
    save_bio
    parse_header
    parse_records
    save_records
  end

  private

  NAME = /NAME:(.*)PARISH/
  PARISH = /PARISH:(.*?)ENTERED/
  ENTERED_SERVICE = /ENTERED\s+SERVICE:(.*)DATES/
  ARCHIVES = /ARCHIVES(.*)Filename/
  DATES = /DATES:(.*)/
  FILENAME = /Filename:(.*)/
  HEADERS = /Outfit Year.*/

  def parse_bio
    text = @file.read

    @bio = Bio.new
    @bio.name = text.match(NAME)[1].strip
    @bio.parish = text.match(PARISH)[1].strip
    @bio.entered_service = text.match(ENTERED_SERVICE)[1].strip
    @bio.dates = text.match(DATES)[1].strip
    @bio.filename = text.match(FILENAME)[1].strip
  end

  def save_bio
    @bio.save!
  end

  def parse_header
    header = retrieve_header
    @header_indexes = { 
      'outfit_years' => 0,
      'positions' => header.index('Position'),
      'posts' => header.index('Post'),
      'districts' => header.index('District'),
      'hbca_references' => header.index('HBCA Reference')
    }
  end

  def retrieve_header
    @file.each do |line|
      if line.match(/^Outfit Year*/)
        @file.rewind
        return line 
      end
    end
  end

  def parse_records
    postings = []
    oy_found = false
    @file.each do |line|
      if line.index('Outfit Year') == 0
        oy_found = true
        next
      end
      next unless oy_found
      if line.match(/^[0-9].*/)
        posting = Posting.new
        posting.years = line[0, @header_indexes['positions']].strip
        posting.position = line[@header_indexes['positions'], @header_indexes['posts'] - @header_indexes['positions']].strip
        posting.post = line[@header_indexes['posts'], @header_indexes['districts'] - @header_indexes['posts']].strip
        posting.district = line[@header_indexes['districts'], @header_indexes['hbca_references'] - @header_indexes['districts']].strip
        posting.hbca_reference = line[@header_indexes['hbca_references'], line.length].strip
        postings << posting
      end
    end
    postings
  end
end
