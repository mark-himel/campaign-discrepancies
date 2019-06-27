require 'active_record'

module Models
  class Campaign < ActiveRecord::Base
    enum status: { active: 0, paused: 1, deleted: 2 }
  end
end
