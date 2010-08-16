## Available reporters

Reporters allows you to display test results in specified way. There are 
few built in reporters in riot. Lets take a look at them.  

### Story

Displays report with test results very similar to known from rspec, bacon 
or shoulda. It's used as default results reporter.  

### Dot-matrix

Well known dot-matrix - simple and nice looking progress bar.  

    Riot.configure do |conf|
      conf.reporter = :dots
    end

### IO Stream

It allows you to save test results to specified stream. It's standard 
output by default, but you can use any type of stream (eg. file stream). 

    Riot.configure do |conf| 
      # write output to STDOUT
      conf.reporter = :io  
      
      # or...
      # require 'riot/reporters/io'
      # conf.reporter = Riot::IOReporter.new(File.open('my/output/file.txt', 'w+'))
    end

### Silent

It displays nothing. If you don't like to see huge reports or running dots 
it's something for you. 

    Riot.configure do |conf|
      conf.reporter = :silent
    end

### Verbose story

A huge and loud report with explained errors. It displays whole backtrase
for each error.

    Riot.configure do |conf|
      conf.reporter = :verbose
    end  
    
