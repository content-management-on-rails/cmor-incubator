Rails.application.config.to_prepare do
  Cmor::Core::Settings::Setting.create!(
    namespace: :cmor_time_tracking,
    key: "external_issue.jira.integration_enabled",
    type: :boolean,
    default: ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_INTEGRATION_ENABLED", false),
    validations: {inclusion: {in: [true, false]}}
  )
  Cmor::Core::Settings::Setting.create!(
    namespace: :cmor_time_tracking,
    key: "external_issue.jira.base_url",
    type: :string,
    default: ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_BASE_URL", nil)
  )

  Cmor::Core::Settings::Setting.create!(
    namespace: :cmor_time_tracking,
    key: "external_issue.jira.username",
    type: :string,
    default: ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_USERNAME", nil),
    validations: {presence: true}
  )

  Cmor::Core::Settings::Setting.create!(
    namespace: :cmor_time_tracking,
    key: "external_issue.jira.api_token",
    type: :string,
    default: ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_API_TOKEN", nil),
    validations: {presence: true}
  )
end
