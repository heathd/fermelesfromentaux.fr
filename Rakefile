require 'fileutils'
require 'pathname'

def basedir
  Pathname.new(File.dirname(__FILE__)) + ".."
end

task :setup do
  (basedir + "shared").mkpath
  (basedir + "releases").mkpath
end

def current_revision
  File.basename(File.readlink(basedir + "current"))
rescue Errno::ENOENT
  nil
end

def latest_revision
  `git rev-parse HEAD`.strip
end

task :cleanup do
  keep = 5
  releases = Dir[basedir + "releases" + "*"]
  if releases.size > keep
    puts "Cleaning old releases (keeping #{keep} newest)"
    releases.sort { |l,r| File.stat(r).mtime <=> File.stat(l).mtime}[keep..-1].each do |f|
      next if File.basename(f) == current_revision
      puts "Remove #{f}"
      output = `rm -rf #{f}`
      raise output unless $?.success?
    end
  end
end

task :get_latest_release do
  output = `git pull`
  raise output unless $?.success?
  if current_revision != latest_revision
    puts "Current revision: #{current_revision}"
    puts "Latest revision: #{latest_revision}"
    puts "Updating..."
    `git archive --format tar HEAD --prefix '#{latest_revision}/' | (cd #{basedir + "releases"}; tar x)`
    `ln -sfn 'releases/#{latest_revision}' '#{basedir + "current"}'`
  end
end

desc "Check for a new release and update if required"
task :update => [:setup, :get_latest_release, :cleanup]