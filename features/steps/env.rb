require 'spec'

# Global setup
#ActionMailer::Base.delivery_method = :test
#ActionMailer::Base.perform_deliveries = true

Before do
  # Scenario setup
#  ActionMailer::Base.deliveries.clear
end

After do
  # Scenario teardown
#  Database.truncate_all
end

at_exit do
  # Global teardown
#  TempFileManager.clean_up
end
