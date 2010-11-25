require 'rake/gempackagetask'
load 'collavoce.gemspec'

gem = Rake::GemPackageTask.new($spec)
gem.define

desc "Push gem to rubygems.org"
task :push => :gem do
  sh "gem push #{gem.package_dir}/#{gem.gem_file}"
end

