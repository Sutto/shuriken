require 'rubygems'
require 'rake'

require 'lib/shuriken'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "shuriken"
    gem.summary     = %Q{Simple Namespace support for JS + Other niceties, packaged as a Barista framework}
    gem.description = %Q{Simple Namespace support for JS + Other niceties, packaged as a Barista framework}
    gem.email       = "sutto@sutto.net"
    gem.homepage    = "http://github.com/Sutto/shuriken"
    gem.version     = Shuriken::VERSION
    gem.authors     = ["Darcy Laycock"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'active_support/all'
require 'barista/rake_task'

Barista::RakeTask.new do |t|
  t.output_directory = 'javascripts'
  t.input_directory  = 'coffeescripts'
  t.bare             = true
  t.add_preamble     = false
end

task :test do
  require 'erb'
  template = ERB.new(File.read("tests/template.erb"))
  FileUtils.mkdir_p 'test-output'
  FileUtils.rm_rf   'test-output/*'
  Dir["tests/*.coffee"].each do |test|
    test_name = File.basename(test, ".coffee")
    $js_file = "#{test_name}.js"
    File.open("test-output/#{test_name}.html", "w+") do |f|
      f.write template.result
    end
    $js_file = nil
    system "coffee", "--no-wrap", "-o", "test-output", "-c", test
  end

  Barista.output_root = rails

end

task :watchr do
  system "watchr tests.watchr"
end
