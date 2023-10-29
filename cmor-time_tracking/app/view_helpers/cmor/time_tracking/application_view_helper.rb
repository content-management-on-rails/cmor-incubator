module Cmor
  module TimeTracking
    class ApplicationViewHelper < Rao::ViewHelper::Base
      def render_items_report(collection: nil, title: nil, collapse: false)
        collection ||= Cmor::TimeTracking::Item.all
        result = Cmor::TimeTracking::ItemsReportService.call(items: collection)

        collapse_css_class = collapse ? "collapse" : "show"

        render(result: result, title: title, collapse_css_class: collapse_css_class)
      end

      def render_project_report(resource:)
        result = Cmor::TimeTracking::ProjectReportService.call(project: resource)
        render(result: result)
      end
    end
  end
end
