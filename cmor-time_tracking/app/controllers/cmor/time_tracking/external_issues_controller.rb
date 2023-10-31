module Cmor
  module TimeTracking
    class ExternalIssuesController < Cmor::Core::Backend::ResourcesController::Base
      def self.resource_class
        Cmor::TimeTracking::ExternalIssue
      end

      def self.available_rest_actions
        %i[index show]
      end

      before_action :load_collection_for_autocomplete, only: [:autocomplete]
      before_action :load_issue_by_key_for_autocomplete, only: [:autocomplete], if: -> { params[:term].present? }

      def autocomplete
        respond_to do |format|
          format.json { render json: (@collection.all << @issue_by_key).compact.map { |q| q.as_json } }
        end
      end

      private

      def load_collection_for_autocomplete
        @collection = load_collection_scope.autocomplete(params[:term])
      end

      def load_issue_by_key_for_autocomplete
        @issue_by_key = load_collection_scope.where(key: params[:term].upcase).first
      end

      def query_params_exceptions
        super + %w[_type]
      end
    end
  end
end
