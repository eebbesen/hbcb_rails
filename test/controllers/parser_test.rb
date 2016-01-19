require 'test_helper'

class ParserTest < Minitest::Test
  def setup
    filename =  File.expand_path("../../fixtures/adams_edward-a.txt", __FILE__)
    @parser = Parser.new(File.open(filename))
  end

  def test_parse_bio
    @parser.send(:parse_bio)

    assert_equal 'ADAMS, Edward (A)', @parser.bio.name
    assert_equal 'Dartmouth, Devon', @parser.bio.parish
    assert_equal '24 April  1869', @parser.bio.entered_service
    assert_equal '', @parser.bio.dates
    assert_equal "Adams, Edward A (fl. 1869-1890) JHB/jhb  November 1990  ;  May/99/mhd;  revised pc May/00", @parser.bio.filename
  end

  def test_header
    header = @parser.send(:retrieve_header)

    assert_equal "Outfit Year*                  Position                               Post                            District                 HBCA Reference\n", header
  end

  def test_parse_header
    # header = "\nOutfit Year*            Position           Post                        District                                 HBCA Reference\n"
    @parser.send(:parse_header)
    header_indexes = @parser.header_indexes

    assert_equal 0, header_indexes['outfit_years']
    assert_equal 30, header_indexes['positions']
    assert_equal 69, header_indexes['posts']
    assert_equal 101, header_indexes['districts']
    assert_equal 126, header_indexes['hbca_references']
  end

  def test_parse_records
    header = @parser.send(:retrieve_header)
    @parser.send(:parse_header)

    postings = @parser.send(:parse_records)

    assert_equal 9, postings.size

    assert_equal '1869, 29 May', postings[0].years
    # overvlow -- 'rador' goes in next field
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
end
