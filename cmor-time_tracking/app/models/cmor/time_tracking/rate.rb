module Cmor::TimeTracking
  class Rate < ApplicationRecord
    has_many :project_rates, dependent: :destroy
    has_many :projects, through: :project_rates

    monetize :unit_net_amount_cents, with_currency: instance_exec(&Cmor::TimeTracking::Configuration.default_currency)

    validates :identifier, presence: true, uniqueness: true
    validates :unit_name, presence: true
    validates :unit_net_amount_cents, presence: true
    validates :unit_tax_rate_percentage, presence: true

    def default?
      identifier == "default"
    end

    def human
      I18n.t("activerecord.values.#{self.class.name.underscore}.human", identifier: identifier, unit_name: unit_name, unit_net_amount_with_currency: unit_net_amount_with_currency, unit_tax_rate_percentage: unit_tax_rate_percentage)
    end

    def unit_net_amount_with_currency
      unit_net_amount.format(symbol: false, with_currency: true)
    end
  end
end
