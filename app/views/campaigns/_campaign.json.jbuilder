# frozen_string_literal: true

json.type "campaign"
json.extract! campaign, :id, :name, :end_date, :status
json.total_budget campaign.total_budget.to_f
json.total_consumed_budget campaign.total_consumed_budget.to_f
json.remaining_budget campaign.remaining_budget.to_f
json.relationships do
  json.organization campaign.user&.organization 
end
json.links do
  json.self campaign_url(campaign)
end
