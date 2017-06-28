def report_errors(errors)
  Airbrake.notify_sync(
    "Testing airbrake errors!",
    parameters: {
      errors: errors,
    }
  )
end

desc "Trigger Airbrake"
task :trigger_airbrake, [] => [:environment] do |_, args|
  report_errors("test")
end
