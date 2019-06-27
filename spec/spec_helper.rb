require "bundler/setup"
require "campaign/discrepancies"
require 'sqlite3'
require 'net/http'
require 'dotenv/load'

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Schema.define do
  self.verbose = false
  create_table "campaigns", force: true do |t|
    t.integer "job_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "external_reference"
    t.text "ad_description"
  end
end
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
