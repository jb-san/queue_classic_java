module QC
  class JdbcAdapterResult
    def initialize(result_set)
      @result_set = result_set
    end

    def each
      meta_data = @result_set.get_meta_data
      while @result_set.next
        row = {}
        (1..meta_data.column_count).each do |i|
          row[meta_data.get_column_name(i)] = @result_set.get_string(i)
        end
        yield row
      end
    end
  end

  class JdbcAdapterConnection
    CONNECTION_OK = nil

    def status
      CONNECTION_OK # don't do any status checking on java
    end

    def self.connect(host, port, opts, tty, dbname, user, password)
      self.new(Java::OrgPostgresql::Driver.new.connect("jdbc:postgresql://#{host}:#{port}/#{dbname}", java.util.Properties.new))
  #   self.new(java.sql.DriverManager.get_connection("jdbc:postgresql://#{host}:#{port}/#{dbname}")) # todo user pass
    end

    def initialize(jdbc_conn)
      @connection = jdbc_conn
    end

    def exec(statement, params)
      statement.gsub!(/\$\d/,'?') unless statement =~ /^CREATE/ # will break table names that have $. also breaks setup code.
      prepared_statement = @connection.prepare_statement(statement)
      params = [] unless params
      params.each_with_index do |p,i|
        p.is_a?(Fixnum) ? prepared_statement.set_int(i+1, p) : prepared_statement.set_string(i+1, p)
      end

      if statement =~ /^SELECT/
        QC::JdbcAdapterResult.new(prepared_statement.execute_query)
      else
        prepared_statement.execute
        []
      end
    end

    def finish
      @connection.close
    end
  end
end

module PG
  class Error < Exception; end
end

PGError = PG::Error
PGconn = QC::JdbcAdapterConnection
