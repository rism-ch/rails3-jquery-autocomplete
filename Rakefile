require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'

task :default => [:uglify, :test]

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :uglify do
  require 'terser'
  file_folder = "lib/assets/javascripts"
  source_file = "#{file_folder}/autocomplete-rails-uncompressed.js"
  output_file = "#{file_folder}/autocomplete-rails.js"

  minified = Terser.new.compile(File.read(source_file))

  File.open(output_file, "w") do |f|
    f << minified
  end
end
