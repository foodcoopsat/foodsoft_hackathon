task spec: ['shared:db:test:prepare']

namespace :shared do
  namespace :db do |ns|
    [:drop, :create, :setup, :migrate, :rollback, :seed, :version].each do |task_name|
      task task_name => :environment do
        Rake::Task["db:#{task_name}"].invoke
      end
    end

    namespace :schema do
      [:load, :dump].each do |task_name|
        task task_name => :environment do
          Rake::Task["db:schema:#{task_name}"].invoke
        end
      end
    end

    namespace :test do
      task prepare: :environment do
        Rake::Task['db:test:prepare'].invoke
      end
    end

    # append and prepend proper tasks to all the tasks defined here above
    ns.tasks.each do |task|
      task.enhance ['shared:set_custom_config'] do
        Rake::Task['shared:revert_to_original_config'].invoke
      end
    end
  end

  task set_custom_config: :environment do
    # save current vars
    @original_config = {
      env_schema: ENV.fetch('SCHEMA', nil),
      config: Rails.application.config.dup
    }

    # set config variables for custom database
    ENV['SCHEMA'] = 'db_shared/schema.rb'
    Rails.application.config.paths['db'] = ['db_shared']
    Rails.application.config.paths['db/migrate'] = ['db_shared/migrate']
    # If you are using Rails 5 or higher change `paths['db/seeds']` to `paths['db/seeds.rb']`
    Rails.application.config.paths['db/seeds'] = ['db_shared/seeds.rb']
    Rails.application.config.paths['config/database'] = ['config/database_shared.yml']
  end

  task revert_to_original_config: :environment do
    # reset config variables to original values
    ENV['SCHEMA'] = @original_config[:env_schema]
    Rails.application.config = @original_config[:config]
  end
end
