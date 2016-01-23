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
    assert_equal '24 April  1869', @parser.bio.entered_service
    assert_equal '', @parser.bio.dates
    assert_equal 'Adams, Edward A (fl. 1869-1890) JHB/jhb  November 1990  ;  May/99/mhd;  revised pc May/00', @parser.bio.filename
  end

  def test_save_bio
    @parser.send(:parse_bio)
    assert_difference 'Bio.count' do
      @parser.send(:save_bio)
    end
  end

  def test_header_with
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
