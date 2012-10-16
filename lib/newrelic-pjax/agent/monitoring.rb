require 'newrelic_rpm'

module NewRelic
  module PJAX
    module Agent
      module Monitoring
        include NewRelic::Agent::BrowserMonitoring
        def pjax_timing_start
          unless NewRelic::Agent.instance.beacon_configuration.nil? || !NewRelic::Agent.is_transaction_traced? || !NewRelic::Agent.is_execution_traced? || NewRelic::Agent::TransactionInfo.get.ignore_end_user?
            %{<script type="text/javascript">
            pjaxTiming['firstByte'] = new Date().getTime();
          </script>
            }.html_safe
          end
        end

        def pjax_timing_end
          config = NewRelic::Agent.instance.beacon_configuration

          if config.nil? ||
            !config.enabled? ||
            NewRelic::Agent.config[:browser_key].nil? ||
            NewRelic::Agent.config[:browser_key].empty? ||
            !NewRelic::Agent.is_transaction_traced? ||
            !NewRelic::Agent.is_execution_traced? ||
            NewRelic::Agent::TransactionInfo.get.ignore_end_user?
            return ""
          end

          pjax_footer_js_string(config)
        end

        def pjax_footer_js_string(config)
          if browser_monitoring_start_time
            %{<script type="text/javascript">
            pjaxTiming['transactionName'] = '#{browser_monitoring_transaction_name}';
            pjaxTiming['queueTime'] = #{browser_monitoring_queue_time};
            pjaxTiming['appTime'] = #{browser_monitoring_app_time};
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
