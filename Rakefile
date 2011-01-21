require 'rake/gempackagetask'

spec = Gem::Specification.load(Dir['*.gemspec'].first)
gem = Rake::GemPackageTask.new(spec)
gem.define

desc "Push gem to rubygems.org"
task :push => :gem do
  sh "gem push #{gem.package_dir}/#{gem.gem_file}"
end

desc "Play a tune"
task :demo do
  sh "ruby -Ilib examples/zelda.rb"
end

desc "Run all specs"
task :specs do
  sh "rspec spec"
end

task :default => :specs
