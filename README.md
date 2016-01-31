# hbcb

Cool data at https://www.gov.mb.ca/chc/archives/hbca/biographical/index.html, but it is stuck in pdfs.

This program downloads the pdfs, converts them to text documents and slurps the information into a searchable database.

## To run
### Download pdfs

    gem install nokogiri
    ruby lib/download_pdfs.rb <start_letter>

You can include a `start_letter` if you've already partially downloaded the files.

You can simulate a run that doesn't download any files by setting environment variable `DRY_RUN`, e.g.

    DRY_RUN=1 ruby lib/download_pdfs.rb <start_letter>

### Convert pdfs to text

    brew update
    brew install xpdf
    lib/pdf_to_text.sh

### Parse and persist bios and postings
To process all of the files matching test/fixtures/*.txt

    bundle exec rake slurp

To process a single file

    bundle exec rake slurp[/absolute/path/to/project/test/fixtures/adan_charles.txt]
    
## etc.
The value of this code (to me) is a working datastore so development is proceeding 'fast and loose'.  One of the many compromises is manually cleaning up data that isn't properly parsed/converted by the default (already ugly, imho) regular expressions.
