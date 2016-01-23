# hbcb

Cool data at https://www.gov.mb.ca/chc/archives/hbca/biographical/index.html, but it is stuck in pdfs.

This program downloads the pdfs, and may someday automate their conversion to text documents.

The final product will be data files/CSV/etc. that can be used as a more traditional, searchable database.

## To run
### Download pdfs

    gem install nokogiri
    ruby lib/download_pdfs.rb [start_letter]

You can include a `start_letter` if you've already partially downloaded the files.

You can simulate a run that doesn't download any files by setting environment variable `DRY_RUN`, e.g.

    'DRY_RUN'=1 ruby download.rb [start_letter]

### Convert pdfs to text

    brew update
    brew install xpdf
    lib/pdf_to_text.sh
