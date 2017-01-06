namespace :db do
    require 'sequel'
    Sequel.extension :migration

    task :migrate do
        puts "task migrate"
        m = Sequel::Migrator
        db = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://decks.sqlite')
        dir = "migrations"
        target = ENV['TARGET'] ? ENV['TARGET'].to_i : nil
        current = ENV['CURRENT'] ? ENV['CURRENT'].to_i : nil
        puts "target: #{target}, current: #{current}"
        m.run(db, dir, :target => target, :current => current)
        puts "migrator finished running"
    end
end
