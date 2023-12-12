Rails.application.config.to_prepare do
  Cmor::Core::Settings.configure do |config|
    config.register(
      namespace: :cmor_time_tracking,
      key: "external_issue.jira.integration_enabled",
      type: :boolean,
      default: ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_INTEGRATION_ENABLED", false),
      validations: {inclusion: {in: [true, false]}}
    )
    
    config.register(
      namespace: :cmor_time_tracking,
      key: "external_issue.jira.base_url",
      type: :string,
      default: ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_BASE_URL", nil)
    )

    config.register(
      namespace: :cmor_time_tracking,
      key: "external_issue.jira.username",
      type: :string,
      default: ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_USERNAME", nil),
      validations: {presence: true}
    )

    config.register(
      namespace: :cmor_time_tracking,
      key: "external_issue.jira.api_token",
      type: :string,
      default: ENV.fetch("CMOR_TIME_TRACKING_EXTERNAL_ISSUE_JIRA_API_TOKEN", nil),
      validations: {presence: true}
    )
  end
end
