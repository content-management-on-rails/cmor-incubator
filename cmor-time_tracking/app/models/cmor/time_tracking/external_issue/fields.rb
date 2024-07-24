module Cmor
  module TimeTracking
    class ExternalIssue::Fields < Rao::ActiveCollection::Base
      attr_accessor :aggregateprogress,
        :aggregatetimeestimate,
        :aggregatetimeoriginalestimate,
        :aggregatetimespent,
        :assignee,
        :components,
        :created,
        :creator,
        :customfield_10000,
        :customfield_10001,
        :customfield_10002,
        :customfield_10003,
        :customfield_10004,
        :customfield_10005,
        :customfield_10006,
        :customfield_10007,
        :customfield_10008,
        :customfield_10009,
        :customfield_10010,
        :customfield_10011,
        :customfield_10012,
        :customfield_10013,
        :customfield_10014,
        :customfield_10015,
        :customfield_10016,
        :customfield_10017,
        :customfield_10018,
        :customfield_10019,
        :customfield_10020,
        :customfield_10021,
        :customfield_10022,
        :customfield_10023,
        :customfield_10024,
        :customfield_10025,
        :customfield_10028,
        :customfield_10100,
        :customfield_10101,
        :customfield_10102,
        :customfield_10103,
        :customfield_10104,
        :customfield_10105,
        :customfield_10106,
        :customfield_10107,
        :customfield_10108,
        :customfield_10109,
        :customfield_10110,
        :customfield_10111,
        :customfield_10112,
        :customfield_10113,
        :customfield_10114,
        :customfield_10115,
        :customfield_10116,
        :customfield_10117,
        :customfield_10118,
        :customfield_10120,
        :customfield_10121,
        :customfield_10122,
        :customfield_10123,
        :customfield_10124,
        :customfield_10125,
        :customfield_10126,
        :customfield_10127,
        :customfield_10128,
        :customfield_10129,
        :customfield_10130,
        :customfield_10131,
        :customfield_10132,
        :customfield_10133,
        :customfield_10134,
        :customfield_10135,
        :customfield_10136,
        :customfield_10137,
        :customfield_10138,
        :customfield_10139,
        :customfield_10141,
        :description,
        :duedate,
        :environment,
        :fix_versions,
        :issuelinks,
        :issuetype,
        :labels,
        :last_viewed,
        :parent,
        :progress,
        :project,
        :reporter,
        :resolution,
        :resolutiondate,
        :security,
        :status,
        :statuscategorychangedate,
        :subtasks,
        :summary,
        :timeestimate,
        :timeoriginalestimate,
        :timespent,
        :updated,
        :versions,
        :votes,
        :watches,
        :workratio

      def issuetype=(value)
        value["url"] = value.delete("self")
        @issuetype = Cmor::TimeTracking::ExternalIssue::Issuetype.new(value)
      end

      def status=(value)
        value["url"] = value.delete("self")
        @status = Cmor::TimeTracking::ExternalIssue::Status.new(value)
      end
    end
  end
end
