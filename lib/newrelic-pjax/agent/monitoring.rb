require 'newrelic_rpm'

module NewRelic
  module PJAX
    module Agent
      module Monitoring
        include NewRelic::Agent::BrowserMonitoring

        def pjax_timing_start
          if insert_js?
            %{<script type="text/javascript">pjaxTiming['firstByte'] = new Date().getTime();</script>}.html_safe
          end
        end

        def pjax_timing_end
          config = NewRelic::Agent.instance.beacon_configuration

          if insert_js?
            pjax_footer_js_string(config)
          end
        end

        def pjax_footer_js_string(config)
          if current_transaction.start_time
            %{<script type="text/javascript">
            pjaxTiming['transactionName'] = '#{browser_monitoring_transaction_name}';
            pjaxTiming['queueTime'] = #{current_timings.queue_time_in_millis};
            pjaxTiming['appTime'] = #{current_timings.app_time_in_millis};
            pjaxTiming['lastByte'] = new Date().getTime();
          </script>}.html_safe
          else
            ''
          end
        end
      end
    end
  end
end


NewRelic::Agent.send(:extend, NewRelic::PJAX::Agent::Monitoring)
