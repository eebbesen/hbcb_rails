##
# Parse a biography sheet into Bio and Postings
class Parser
  attr_reader :bio, :postings

  def initialize(filename)
    @lines = []
    File.open(filename, :encoding => 'iso-8859-1').each do |line|
      @lines << line
    end
  end

  def parse
    parse_bio
    save_bio
    parse_postings
    save_postings
  end

  private

  NAME = /(?:NAME|Ne AME|^AME):?(.*?)(PARISH|PLACE\s+OF|BIRTHPLACE|RESIDENCE|ADDRESS|NATIONALITY)/im
  PARISH = /(?:PARISH|RESIDENCE|ADDRESS):(.*?)(?:ENTERED\s+SERVICE|SERVICE)/i
  PLACE_OF_BIRTH = /(?:PLACE\s+OF\s+BIRTH|BIRTHPLACE|NATIONALITY):(.*?)ENTERED/i
  ENTERED_SERVICE = /(?:ENTERED\s+SERVICE|SERVICE):(.*)DATES/i
  ARCHIVES = /ARCHIVES(.*)Filename/i
  DATES = /DATES:(.*)/i
  FILENAME = /Filename:(.*)/i
  HEADERS = /Outfit Year.*/i
  SUFFIX = /\s*([sj]r)\.?$/i

  def parse_bio
    text = @lines.join("\n")

    @bio = Bio.new
    @bio.name = safe_match text, NAME
    @bio.first_name, @bio.middle_name, @bio.last_name = parse_name(@bio.name)
    @bio.parish = safe_match text, PARISH
    @bio.place_of_birth = safe_match text, PLACE_OF_BIRTH
    @bio.entered_service = safe_match text, ENTERED_SERVICE
    @bio.dates = safe_match text, DATES
    @bio.filename = safe_match text, FILENAME
  end

  def parse_name(name)
    full_name = name.downcase.gsub(/[()"\'\.,]/, ' ').gsub(/\s+/, ' ').split(/\s/m)
    suffix = safe_match(full_name.last, SUFFIX)
    full_name.pop if !suffix.blank?
    full_name = full_name.join(' ').strip.split(' ')
    last = full_name.shift
    first = full_name.shift
    middle = full_name.join ' '
    [[first, suffix].join(' '), middle, last].map do |x|
      x = x.strip if x
    end
  end

  def safe_match(line, regex)
    unless line.blank?
      value = line.match(regex)
      return value[1].strip if (value && value[1])
    end
    ''
  end

  def parse_postings
    header_indexes = parse_postings_header
    @postings = []
    oy_found = false
    @lines.each do |line|
      if line.index('Outfit Year') == 0
        oy_found = true
        next
      end
      next unless oy_found
      if line.match(/^[0-9].*/)
        Rails.logger.debug line
        posting = Posting.new
        posting.bio_id = @bio.id
        posting.years = safe_extract_value line, 0, header_indexes['positions']
        post_ship_index = header_indexes['posts'] || header_indexes['ships']
        posting.position = safe_extract_value line, header_indexes['positions'], post_ship_index
        posting.post = safe_extract_value line, post_ship_index, header_indexes['districts']
        posting.district = safe_extract_value line, header_indexes['districts'], header_indexes['hbca_references']
        posting.hbca_reference = safe_extract_value line, header_indexes['hbca_references'], line.length
        @postings << posting
      end
    end
    @postings
  end

  def safe_extract_value(line, start, next_start)
    return '' if [line, start, next_start].include? nil
    value = line[start, next_start - start]
    return value.strip if value
    ''
  end

  def save_bio
    Rails.logger.debug(@bio)
    @bio.save!
  end

  def save_postings
    @postings.each do |posting| 
      Rails.logger.debug(posting)
      posting.save!
    end
  end

  def parse_postings_header
    header = retrieve_header
    {
      'outfit_years' => 0,
      'positions' => header.index('Position'),
      'posts' => header.index('Post'),
      'ships' => header.index('Ship'),
      'districts' => header.index('District'),
      'hbca_references' => header.index('HBCA Reference')
    }
  end

  def retrieve_header
    @lines.each do |line|
      if line.match(/^Outfit Year*/)
        Rails.logger.debug line
        return line
      end
    end
  end

end
