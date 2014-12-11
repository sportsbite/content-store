module MongoInstrumentation
  # Used to extend ActionController to output additional logging information on
  # the duration of Mongo queries.
  module ControllerRuntime
    extend ActiveSupport::Concern

    protected

    def append_info_to_payload(payload)
      super
      payload[:db_runtime] = MongoInstrumentation::MopedSubscriber.runtime || 0
      payload[:query_count] = MongoInstrumentation::MopedSubscriber.query_count || 0
      MongoInstrumentation::MopedSubscriber.reset_instruments
    end

    module ClassMethods
      def log_process_action(payload)
        super.tap do |messages|
          runtime = payload[:db_runtime]
          messages << ("Mongo: %.1fms" % runtime.to_f)
          messages << ("Mongo query count: #{payload[:query_count]}")
        end
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  include MongoInstrumentation::ControllerRuntime
end
