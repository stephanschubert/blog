watch( "spec/.*/*_spec\.rb" ) { |m| run_spec m[0] }
watch( "app/(.*/.*)\.rb"    ) { |m| run_spec "spec/#{m[1]}_spec.rb" }

def run_spec(file)
  unless File.exist?(file)
    puts "#{file} does not exist"
  else
    puts "Running #{file}"
    system "bundle exec rspec #{file}"
    puts
  end
end

def run_all_specs
  system "bundle exec rspec spec"
end

Signal.trap 'INT' do
  if @interrupt_received
    exit 0
  else
    @interrupt_received = true
    puts "\nInterrupt a second time to quit"
    Kernel.sleep 2
    @interrupt_received = false
    puts "Running all specs..."
    run_all_specs
  end
end
