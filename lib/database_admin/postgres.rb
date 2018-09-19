require 'sequel'

module DatabaseAdministrator
  class Postgres
    def initialize
      @migrator = Migrator.new
    end

    def fresh_database
      database = existing_database

      @migrator.destroy(database)
      @migrator.migrate(database)

      database
    end

    def existing_database
      database = Sequel.connect('postgresql://admin:secretpassword@postgres/orders')

      @migrator.migrate(database)
      database
    end
  end
end
