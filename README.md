# Campaign::Discrepancies

A very simple campaign discrepancy detector gem where it'll track down the difference between the local and remote campaigns. It'll very simple track down by comparing the status and the description of the same campaign that both in local and in remote.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'campaign-discrepancies', git: 'https://github.com/mark-himel/campaign-discrepancies.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install campaign-discrepancies

## Usage

There needs to be an existing model structure of campaign like below:
```ruby
create_table "campaigns", force: :cascade do |t|
    t.uuid "job_id", default: -> { "uuid_generate_v4()" }, null: false
    t.integer "status", default: 0, null: false
    t.integer "external_reference"
    t.text "ad_description"
  end
```

This gem uses an environment variable where an application's third party url will be stored in case if not given then it'll take the default url
```ruby
EXTERNAL_URL - the env variable under which the url will be set
```

After you have the table structure and the configuration of url it's very simple
```ruby
Campaign::Discrepancies::Identify.call
```

Calling the above execution will provide you an array of hashes, the hashes would be each discrepancies of a local vs remote campaign. The response would look like below:
```ruby
      [
        {
          remote_reference: "1",
          discrepancies: [
            {
              status: {
                remote: "enabled",
                local: "active"
              },
              description: {
                remote: "Description for campaign 11",
                local:"Java Developer"
              }
            }
          ]
        },
        {
          remote_reference: "2",
          discrepancies: [
            {
              status: {
                remote: "disabled",
                local: "Not present"
              },
              description: {
                remote: "Description for campaign 12",
                local: "No description"
              }
            }
          ]
        },
        {
          remote_reference: "3",
          discrepancies: [
            {
              status: {
                remote: "enabled",
                local: "Not present"
              },
              description: {
                remote: "Description for campaign 13",
                local: "No description",
              }
            }
          ]
        }
      ]
```
## Contributing

Bug reports and pull requests are welcome on GitHub at [Mark's Hub](https://github.com/mark-himel/campaign-discrepancies). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Campaign::Discrepancies project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/campaign-discrepancies/blob/master/CODE_OF_CONDUCT.md).
