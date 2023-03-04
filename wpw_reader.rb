require "pdf-reader"


class Extractor

  def page(page)
    process_page(page, 0)
  end

private

  # def complete_refs
      # @complete_refs ||= {}
  # end

  def process_page(page, count)
    xobjects = page.xobjects
    return count if xobjects.empty?

    xobjects.each do |name, stream|
      case stream.hash[:Subtype]
      when :Image then
        count += 1

        case stream.hash[:Filter]
        # when :CCITTFaxDecode then
          # ExtractImages::Tiff.new(stream).save("#{page.number}-#{count}-#{name}.tif")
        when :DCTDecode      then
          Jpg.new(stream).save("./Images/#{page.number}-#{count}-#{name}.jpg")
        # else
          # ExtractImages::Raw.new(stream).save("#{page.number}-#{count}-#{name}.tif")
        end
      when :Form then
        count = process_page(PDF::Reader::FormXObject.new(page, stream), count)
      end
    end
    count
  end

end


class Jpg
  attr_reader :stream

  def initialize(stream)
    @stream = stream
  end

  def save(filename)
    w = stream.hash[:Width]
    h = stream.hash[:Height]
    puts "#{filename}: h=#{h}, w=#{w}"
    File.open(filename, "wb") { |file| file.write stream.data }
  end
end
  
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
# puts reader.objects.inspect

extractor = Extractor.new

reader.pages.each do |page|
  # puts page.fonts
  # puts page.text
  # puts page.raw_content
  # puts page.inspect
  # puts page.number
  extractor.page(page)
end



