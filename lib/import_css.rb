# A filter to process stylesheets and resolve @import rules at compile time
#
# Idea (and code, with slight modifications) from the nanoc template project:
# https://github.com/avdgaag/nanoc-template/blob/master/lib/concat_filter.rb

class ImportCSSFilter < Nanoc3::Filter
  identifier :import_css

  def run(content, args = {})
    content.gsub(%r{^\s*(?:@import(?: url)?\(?([a-zA-Z0-9_\-\.]+)\)?)$}) do |m|
      load_file($1) || m
    end
  end

private

  def load_file(filename)
    path = File.join(File.dirname(item[:content_filename]), filename)

    unless File.exists? path
      path = File.join(File.dirname(__FILE__), '..', 'vendor', filename)
    end

    return unless File.exists? path

    File.read(path)
  end
end
