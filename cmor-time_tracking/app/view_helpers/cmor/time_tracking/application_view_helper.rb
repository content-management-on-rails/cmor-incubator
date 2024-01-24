module Cmor
  module TimeTracking
    # Usage:
    #
    #    # app/controllers/application_controller.rb
    #    class ApplicationController < ActionController::Base
    #      view_helper Cmor::TimeTracking::ApplicationViewHelper, as: :time_tracking_helper
    #    end
    #
    class ApplicationViewHelper < Rao::ViewHelper::Base
      def render_items_report(collection: nil, title: nil, collapse: false)
        collection ||= Cmor::TimeTracking::Item.all
        result = Cmor::TimeTracking::ItemsReportService.call(items: collection)

        collapse_css_class = collapse ? "collapse" : "show"

        render(result: result, title: title, collapse_css_class: collapse_css_class)
      end

      # Usage:
      #
      #    # app/views/projects/show.html.haml
      #    = time_tracking_helper(self).render_project_report(resource: current_user.projects.find(params[:id]))
      def render_project_report(resource:, visibility:)
        result = Cmor::TimeTracking::ProjectReportService.call(project: resource, visibility: visibility)
        render(result: result)
      end

      def render_hours_by_project_report(collection: nil, title: nil, collapse: false)
        collection ||= Cmor::TimeTracking::Item.all
        result = Cmor::TimeTracking::ItemsByProjectReportService.call(items: collection)

        collapse_css_class = collapse ? "collapse" : "show"

        render(result: result, title: title, collapse_css_class: collapse_css_class)
      end
    end
  end
end
