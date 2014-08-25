#!/usr/bin/env ruby
require 'aws-sdk'

s3 = AWS::S3.new
bucket = s3.buckets['zooniverse-static']

build = <<-BASH
rm -rf build
cp -R public pre_build_public
cp -RL public build_public
rm -rf public
mv build_public public
echo 'Building...'
coffee build.coffee
hem build
mv public build
mv pre_build_public public
BASH

timestamp = `date -u +%Y-%m-%d_%H-%M-%S`.chomp

compress = <<-BASH
echo 'Compressing...'

timestamp=#{timestamp}

mv build/application.js "build/application-$timestamp.js"
mv build/nfn/build.js "build/nfn/build-$timestamp.js"
./node_modules/clean-css/bin/cleancss build/application.css -o "build/application-$timestamp.css"
rm build/application.css
BASH

system build
system compress

index = File.read 'build/index.html'
index.gsub! 'application.js', "application-#{ timestamp }.js"
index.gsub! 'build.js', "build-#{ timestamp }.js"
index.gsub! 'application.css', "application-#{ timestamp }.css"
File.open('build/index.html', 'w'){ |f| f.puts index }

working_directory = Dir.pwd
Dir.chdir 'build'
to_upload = Dir['**/*'].reject{ |path| File.directory? path }
to_upload.delete 'index.html'
to_upload << 'index.html'
total = to_upload.length

to_upload.each.with_index do |file, index|
  content_type = case File.extname(file)
  when '.html'
    'text/html'
  when '.js'
    'application/javascript'
  when '.css'
    'text/css'
  when '.gz'
    'application/x-gzip'
  when '.ico'
    'image/x-ico'
  else
    `file --mime-type -b #{ file }`.chomp
  end

  puts "#{ '%2d' % (index + 1) } / #{ '%2d' % total }: Uploading #{ file } as #{ content_type }"

  options = {
    acl: :public_read,
    content_type: content_type
  }

  if file == 'index.html'
    options[:cache_control] = 'no-cache'
  end

  path = Pathname.new(file)
  bucket.objects["www.notesfromnature.org/#{file}"].write(path, options)
end

Dir.chdir working_directory
`rm -rf build`
puts 'Done!'
