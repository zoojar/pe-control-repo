# frozen_string_literal: true

require 'json'

def factset(os)
  f = File.expand_path(File.join(File.dirname(__FILE__), "factsets/#{os}.json"))
  return {} unless File.exist?(f) && File.readable?(f) && File.size?(f)

  RSpec.configuration.reporter.message "Loading factset from #{f}"
  data = JSON.parse(File.read(f))
  data.is_a?(Hash) ? (data['values'] || data) : {}
rescue StandardError => e
  RSpec.configuration.reporter.message "WARNING: Unable to parse #{f}: #{e}"
  {}
end

# Wrap on_supported_os only once
if defined?(RspecPuppetFacts) &&
   RspecPuppetFacts.respond_to?(:instance_methods) &&
   RspecPuppetFacts.instance_methods.include?(:on_supported_os) &&
   !RspecPuppetFacts.instance_methods.include?(:__orig_on_supported_os)

  RspecPuppetFacts.module_eval do
    alias_method :__orig_on_supported_os, :on_supported_os

    def on_supported_os(options = {})
      __orig_on_supported_os(options).each_with_object({}) do |(os, os_facts), acc|
        acc[os] = os_facts.merge(factset(os))
      end
    end
  end
end