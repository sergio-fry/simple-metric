require 'rails/generators'
require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class SimpleMetricGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_migrations
        migration_template 'migration.rb', "#{Rails.root}/db/migrations/create_metrics.rb", migration_version: migration_version
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end
    end
  end
end
