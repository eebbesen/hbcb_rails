require 'test_helper'
require 'parser'

class Parser
  def postings=(postings)
    @postings = postings
  end
end

class ParserTest < ActiveSupport::TestCase
  def setup
    filename = File.expand_path('../../fixtures/adams_edward-a.txt', __FILE__)
    @parser = Parser.new(filename)
  end

  def test_parse_bio
    @parser.send(:parse_bio)

    assert_equal 'ADAMS, Edward (A)', @parser.bio.name
    assert_equal 'Dartmouth, Devon', @parser.bio.parish
    assert_equal '', @parser.bio.place_of_birth
    assert_equal '24 April  1869', @parser.bio.entered_service
    assert_equal '', @parser.bio.dates
    assert_equal 'Adams, Edward A (fl. 1869-1890) JHB/jhb  November 1990  ;  May/99/mhd;  revised pc May/00', @parser.bio.filename
  end

  def test_parse_bio_with_place_of_birth
    filename = File.expand_path('../../fixtures/adan_charles.txt', __FILE__)
    @parser = Parser.new(filename)

    @parser.send(:parse_bio)

    assert_equal 'ADAN, CHARLES', @parser.bio.name
    assert_equal 'Old Machar, Aberdeen', @parser.bio.place_of_birth
    assert_equal '', @parser.bio.parish
    assert_equal '3 Aug. 1922', @parser.bio.entered_service
    assert_equal '24 July 1901-', @parser.bio.dates
    assert_equal 'Adan, Charles (1901-) (fl. 1922-1938); AM 00/03; rev. 2002/10', @parser.bio.filename
  end

  def test_parse_bio_with_birthplace
    filename = File.expand_path('../../fixtures/desmeules_leo-joseph.txt', __FILE__)
    @parser = Parser.new(filename)

    @parser.send(:parse_bio)

    assert_equal 'DESMEULES, Leo Joseph', @parser.bio.name
    assert_equal 'Big River, SK', @parser.bio.place_of_birth
    assert_equal '', @parser.bio.parish
    assert_equal 'April, 1936', @parser.bio.entered_service
    assert_equal '19  Sept.  1919  -', @parser.bio.dates
    assert_equal 'Desmeules, Leo Joseph (fl. 1936-1937) ; AM/Dec. 1995 ; June/99/mhd', @parser.bio.filename
  end

  def test_parse_bio_without_colons
    filename = File.expand_path('../../fixtures/albert[albert_one-eye).txt', __FILE__)
    @parser = Parser.new(filename)

    @parser.send(:parse_bio)

    assert_equal 'ALBERT', @parser.bio.name
    assert_equal '', @parser.bio.place_of_birth
    assert_equal '', @parser.bio.parish
    assert_equal '', @parser.bio.entered_service
    assert_equal 'b.ca. 1824', @parser.bio.dates
    assert_equal 'Albert [Albert One-Eye] (b.ca.1824-1849)  Copied from binder copy PC June/01', @parser.bio.filename
  end

  def test_parse_bio_with_lower_case
    filename = File.expand_path('../../fixtures/black_edward_alexander1907.txt', __FILE__)
    @parser = Parser.new(filename)

    @parser.send(:parse_bio)

    assert_equal 'BLACK, Edward Alexander', @parser.bio.name
    assert_equal 'Turiff, Scotland', @parser.bio.place_of_birth
    assert_equal '', @parser.bio.parish
    assert_equal '7  May  1926', @parser.bio.entered_service
    assert_equal 'b.1907', @parser.bio.dates
    assert_equal 'Black, Edward Alexander (1907-) (1926-1934); TS 01/2011', @parser.bio.filename
  end

  def test_parse_bio_with_multiple_matches
    filename = File.expand_path('../../fixtures/allen_nicholas(1768).txt', __FILE__)
    @parser = Parser.new(filename)

    @parser.send(:parse_bio)

    assert_equal 'ALLEN, Nicholas', @parser.bio.name
    assert_equal '', @parser.bio.place_of_birth
    assert_equal 'South Ronaldsha,       North  Parish', @parser.bio.parish
    assert_equal '29 June 1790', @parser.bio.entered_service
    assert_equal 'b. ca. 1768', @parser.bio.dates
    assert_equal 'Allen, Nicholas (b. ca. 1768) (fl. 1790-1795)  JHB 1999/01  Revised pc May/00', @parser.bio.filename
  end

  def test_parse_bio_with_misformed_bio_line_newline
    filename = File.expand_path('../../fixtures/bonneau_jean-baptiste.txt', __FILE__)
    @parser = Parser.new(filename)

    @parser.send(:parse_bio)

    assert_equal 'BONNEAU, Jean-Baptiste', @parser.bio.name
    assert_equal '', @parser.bio.place_of_birth
    assert_equal 'CA', @parser.bio.parish
    assert_equal '1811-1821', @parser.bio.entered_service
    assert_equal '', @parser.bio.dates
    assert_equal 'Bonneau, Jean-Baptiste (fl. 1811-1821) CO 2002 August', @parser.bio.filename
  end

  def test_parse_bio_with_misformed_bio_line_newline_splitting_data
    filename = File.expand_path('../../fixtures/boucher_james.txt', __FILE__)
    @parser = Parser.new(filename)

    @parser.send(:parse_bio)

    assert_equal "BOUCHER, James\n\n\n\n              (Bouché)", @parser.bio.name
    assert_equal '', @parser.bio.place_of_birth
    assert_equal 'Native', @parser.bio.parish
    assert_equal '(fl. 1841-1844)', @parser.bio.entered_service
    assert_equal '', @parser.bio.dates
    assert_equal 'Boucher, James (Bouché) (fl.1841-1844) CO 2002 August         WINNIPEG', @parser.bio.filename
  end

  # Consider preprocessing this out -- only happens twice in data set
  def test_parse_bio_with_misformed_bio_line_ne_ame
    filename = File.expand_path('../../fixtures/brabant_angus.txt', __FILE__)
    @parser = Parser.new(filename)

    @parser.send(:parse_bio)

    assert_equal 'BRABANT, Angus', @parser.bio.name
    assert_equal '', @parser.bio.place_of_birth
    assert_equal '', @parser.bio.parish
    assert_equal '(fl. 1886-1927)', @parser.bio.entered_service
    assert_equal '(b. May 31, 1866', @parser.bio.dates
    assert_equal 'Brabant, Angus (b.1866-1928) (fl. 1920) CO 2002 August', @parser.bio.filename
  end

  def test_parse_bio_with_misformed_bio_line_ame
    filename = File.expand_path('../../fixtures/henderson_donald.txt', __FILE__)
    @parser = Parser.new(filename)

    @parser.send(:parse_bio)

    assert_equal 'HENDERSON, Donald', @parser.bio.name
    assert_equal '', @parser.bio.place_of_birth
    assert_equal 'Brawl, Halkirk Parish', @parser.bio.parish
    assert_equal '1829, 1 June', @parser.bio.entered_service
    assert_equal 'b. ca. 1811', @parser.bio.dates
    assert_equal 'Henderson, Donald (ca. 1811-1859) (fl. 1829-1859); JHB/ek March l987', @parser.bio.filename
  end

  def test_parse_bio_with_residence
    filename = File.expand_path('../../fixtures/good_hubert.txt', __FILE__)
    @parser = Parser.new(filename)

    @parser.send(:parse_bio)

    assert_equal 'GOOD, Hubert Ernst P.', @parser.bio.name
    assert_equal '', @parser.bio.place_of_birth
    assert_equal 'Nanaimo, BC', @parser.bio.parish
    assert_equal '1 June     1893', @parser.bio.entered_service
    assert_equal '', @parser.bio.dates
    assert_equal 'Good,  Hubert  Ernst  P.  (bapt. 1875) (fl. 1893-1896); JHB/jhb Feb. 1991', @parser.bio.filename
  end

  def test_parse_bio_with_address
    filename = File.expand_path('../../fixtures/wheeler_roy-thomas.txt', __FILE__)
    @parser = Parser.new(filename)

    @parser.send(:parse_bio)

    assert_equal 'WHEELER, ROY THOMAS', @parser.bio.name
    assert_equal '', @parser.bio.place_of_birth
    assert_equal '12 Kemble Road', @parser.bio.parish
    assert_equal '8 May 1928', @parser.bio.entered_service
    assert_equal 'b. ca. 1910', @parser.bio.dates
    assert_equal 'Wheeler, Roy Thomas (b. ca. 1910) (fl. 1928-1933) JHB 10/95', @parser.bio.filename
  end

  def test_save_bio
    @parser.send(:parse_bio)
    assert_difference 'Bio.count' do
      @parser.send(:save_bio)
    end
  end

  def test_header
    header = @parser.send(:retrieve_header)

    assert_equal "Outfit Year*                  Position                               Post                            District                 HBCA Reference\n", header
  end

  def test_parse_postings_header_with_post
    header_indexes =  @parser.send(:parse_postings_header)

    assert_equal 0, header_indexes['outfit_years']
    assert_equal 30, header_indexes['positions']
    assert_equal 69, header_indexes['posts']
    assert_equal 101, header_indexes['districts']
    assert_equal 126, header_indexes['hbca_references']
    assert_nil header_indexes['ships']
  end

  def test_parse_postings_header_with_ship
    filename = File.expand_path('../../fixtures/adams_james.txt', __FILE__)
    @parser = Parser.new(filename)

    header_indexes =  @parser.send(:parse_postings_header)

    assert_equal 0, header_indexes['outfit_years']
    assert_equal 44, header_indexes['positions']
    assert_equal 71, header_indexes['ships']
    assert_equal 117, header_indexes['districts']
    assert_equal 142, header_indexes['hbca_references']
    assert_nil header_indexes['posts']
  end


  def test_parse_postings
    @parser.send(:retrieve_header)
    @parser.send(:parse_postings_header)

    postings = @parser.send(:parse_postings)

    assert_equal 9, postings.size

    assert_equal '1869, 29 May', postings[0].years
    # overflow -- 'rador' goes in next field
    assert_equal 'Entered on board ship travelling to Lab', postings[0].position
    assert_equal 'rador', postings[0].post
    assert_equal '', postings[0].district
    assert_equal 'A.32/20 fo. 1-2', postings[0].hbca_reference

    assert_equal '1878-1879', postings[4].years
    assert_equal 'Clerk', postings[4].position
    assert_equal 'North West River', postings[4].post
    assert_equal 'Esquimaux Bay', postings[4].district
    assert_equal 'B.134/g/51; A.32/20 fo.4', postings[4].hbca_reference

    assert_equal '1880 (season)', postings[5].years
  end

  def test_parse_postings_ship
    filename = File.expand_path('../../fixtures/adams_james.txt', __FILE__)
    @parser = Parser.new(filename)

    postings = @parser.send(:parse_postings)

    assert_equal 3, postings.size

    assert_equal '1840, 20 Aug.-1841, 1 Apr.', postings[0].years
    assert_equal 'Seaman', postings[0].position
    assert_nil postings[0].ship
    assert_equal 'London-Columbia', postings[0].district
    assert_equal 'C.3/14 fo. 100', postings[0].hbca_reference

    assert_equal '1841, 1 April', postings[1].years
    assert_equal 'Drowned at Fort Vancouver', postings[1].position
    assert_nil postings[1].ship
    assert_equal '', postings[1].district
    assert_equal 'C.1/257 fo. 94d', postings[1].hbca_reference
  end

  def test_save_postings
    @parser.postings = [Posting.new, Posting.new]

    assert_difference 'Posting.count', 2 do
      @parser.send(:save_postings)
    end
  end

  def test_safe_extract_value
    line = 'The waitress jumped over the table and begged, "Can I take your picture?"'

    assert_equal 'waitress', @parser.send(:safe_extract_value, line, 3, 13)
    assert_equal 'waitress j', @parser.send(:safe_extract_value, line, 3, 14)
    assert_equal '', @parser.send(:safe_extract_value, line, 100, 101)
    assert_equal '', @parser.send(:safe_extract_value, line, nil, nil)
    assert_equal '', @parser.send(:safe_extract_value, nil, nil, nil)
  end

  def test_safe_match
    line = 'Pennsylvania, the 6AM cold sun leaves me waiting on the thread of someone'

    assert_equal '6AM', @parser.send(:safe_match, line, /(6AM )/)
    assert_equal '', @parser.send(:safe_match, line, /Hopalong/)
  end

end
