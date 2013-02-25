require 'fileutils'
require 'pathname'
require 'net/http'
require 'faraday'
require 'json'

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

def get_latest_revision
  conn = Faraday.new(:url => 'https://api.github.com/')
  response = conn.get("/repos/heathd/fermelesfromentaux.fr/git/refs/head")
  JSON.parse(response.body).first['object']['sha']
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
  latest_revision = get_latest_revision
  if current_revision != latest_revision
    puts "Current revision: #{current_revision}"
    puts "Latest revision: #{latest_revision}"
    puts "Updating..."
    `git pull && git archive --format tar HEAD --prefix '#{latest_revision}/' | (cd #{basedir + "releases"}; tar x)`
    `ln -sfn 'releases/#{latest_revision}' '#{basedir + "current"}'`
  end
end

desc "Check for a new release and update if required"
task :update => [:setup, :get_latest_release, :cleanup]