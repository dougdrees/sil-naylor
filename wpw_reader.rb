require "pdf-reader"

##############################################
if ARGV.length > 0
  filename = ARGV.at(0).chomp
else
  filename = "west_plains_wordlists.pdf"
end

reader = PDF::Reader.new(filename)

puts reader.pdf_version
puts reader.info
puts reader.metadata
puts reader.page_count