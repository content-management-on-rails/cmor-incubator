module Cmor
  module TimeTracking
    class ExternalIssue
      extend ActiveModel::Model
      extend ActiveModel::Naming
      extend ActiveModel::Translation
      include ActiveModel::Attributes
      include ActiveModel::AttributeAssignment
      include ActiveModel::Conversion

      attribute :key, :string
      attribute :project, :string
      attribute :expand
      attribute :id
      attribute :fields
      attribute :url

      attribute :issuetype_name
      attribute :summary

      delegate :summary, to: :fields

      def fields=(value)
        super(Cmor::TimeTracking::ExternalIssue::Fields.new(value))
      end

      def self.autocomplete(term)
        return none if term.blank?
        all.where(["summary LIKE ?", term.downcase])
      end

      # define_attribute_methods :key

      class Relation
        class WhereCondition
          def initialize(conditions)
            @conditions = conditions
          end

          def append(jql)
            [jql, conditions_as_jql].compact_blank.join(" AND ")
          end

          def conditions_as_jql
            case @conditions
            when Array
              query = @conditions.first.split(".").last
              process_like_operations(query)
            when Hash
              @conditions.map do |key, value|
                "#{key} = #{value}"
              end.join(" AND ")
            else
              raise "Unsupported condition type: #{@conditions.class.name}"
            end
          end

          def process_like_operations(query)
            query = query.gsub("LIKE", "~")
            ActiveRecord::Base.send(:sanitize_sql_array, [query, @conditions[1..]])
          end
        end

        include Enumerable

        def initialize(klass)
          @klass = klass
          @where_conditions = []
        end

        def each
          # rubocop:disable Style/For
          for item in load_collection! do
            yield item
          end
          # rubocop:enable Style/For
        end

        #        def load_collection!
        #          collection = []
        #          @where_conditions.each do |condition|
        #            collection = condition.apply(collection)
        #          end
        #          collection
        #        end

        def load_collection!
          jql = ""
          @where_conditions.each do |condition|
            jql = condition.append(jql)
          end
          load_issues_from_jira!(jql)
        end

        def where(conditions)
          @where_conditions << WhereCondition.new(conditions)
          self
        end

        def all
          load_collection!
        end

        def none
          Cmor::TimeTracking::ExternalIssue::NullRelation.new
        end

        def jira_base_url
          Cmor::Core::Settings.get("cmor_time_tracking/external_issue.jira.base_url")
        end

        def jira_basic_auth_token
          Base64.strict_encode64(
            [
              Cmor::Core::Settings.get("cmor_time_tracking/external_issue.jira.username"),
              Cmor::Core::Settings.get("cmor_time_tracking/external_issue.jira.api_token")
            ].join(":")
          )
        end

        def load_issues_from_jira!(jql)
          puts "Loading issues from jira with JQL #{jql}..."
          result = HTTParty.post(
            "#{jira_base_url}/rest/api/2/search",
            body: {
              jql: jql
            }.to_json,
            headers: {
              "Content-Type" => "application/json",
              "Authorization" => "Basic #{jira_basic_auth_token}}"
            }
          )

          if result.code == 400
            puts "Could not load issues from jira: #{result.parsed_response["errorMessages"]}"
            return []
          end
          if result.code != 200
            raise "Error while loading issues from jira: #{result.parsed_response}"
          end
          puts "Loaded #{result.parsed_response["issues"].size} issues from jira"
          result.parsed_response["issues"].map do |issue|
            issue["url"] = issue.delete("self")
            @klass.new(issue)
          end
        end
      end

      class NullRelation
        include Enumerable

        def all
          []
        end

        def each
          # rubocop:disable Style/For
          for item in all do
            yield item
          end
          # rubocop:enable Style/For
        end
      end

      class << self
        delegate :where, to: :all
      end

      def self.all
        Cmor::TimeTracking::ExternalIssue::Relation.new(self)
      end

      def self.none
        Cmor::TimeTracking::ExternalIssue::Relation.new(self).none
      end

      def self.table_name
        name.underscore.tr("/", "_").pluralize
      end

      def self.columns_hash
        @columns_hash ||= attribute_names.each_with_object({}.with_indifferent_access) do |attribute, hash|
          hash[attribute] = OpenStruct.new(name: attribute, type: String)
        end
      end

      def initialize(attrs = {})
        @attributes = self.class._default_attributes.deep_dup
        assign_attributes(attrs)
        # @attributes = self.class._default_attributes.deep_dup
        # attrs.each do |key, value|
        #   @attributes[key.to_sym] = value
        # end
      end

      delegate :as_json, to: :attributes
    end
  end
end