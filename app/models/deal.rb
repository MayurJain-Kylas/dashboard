# frozen_string_literal: true

class Deal < ApplicationRecord
  belongs_to :tenant
  enum status: { CLOSED_LOST: 0, CLOSED_WON: 1, CLOSED_DISQUALIFIED: 2 }
end

