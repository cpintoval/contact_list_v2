require 'pg'

class Number

  # Instance Methods
  attr_accessor :tag, :number
  attr_reader :contactid, :id

  def initialize(contactid, tag, number, id = nil)
    @contactid = contactid
    @tag = tag
    @number = number
    @id = id
  end

  def persisted?
    !id.nil?
  end

  def save
    if persisted?
      sql = "UPDATE numbers SET tag = $1, number = $2 WHERE id = #{id};"
      self.class.connection.exec_params(sql, [tag, number])
    else
      sql = "INSERT INTO numbers (contactid, tag, number) VALUES ($1, $2, $3) RETURNING id;"
      out = self.class.connection.exec_params(sql, [contactid, tag, number])
      @id = out[0]['id'].to_i
    end
    true
  rescue
    false
  end

  def destroy
    sql = "DELETE FROM numbers WHERE id = $1;"
    self.class.connection.exec_params(sql, [id])
    self
  end

  class << self

    def connection
      PG.connect(
        host: 'localhost',
        dbname: 'contactsdb',
        user: 'development',
        password: 'development'
      )
    end

    def find(id)
      sql = "SELECT * FROM numbers WHERE id = $1;"
      connection.exec_params(sql, [id]) do |response|
        result = response.values[0]
        Number.new(result[1], result[2], result[3], result[0])
      end
    rescue
      nil
    end

    def find_all_by_contactid(id)
      contacts = []

      sql = "SELECT * FROM numbers WHERE contactid = $1;"
      connection.exec_params(sql, [id]) do |response|
        response.values.each do |row|
          contacts << Number.new(row[1], row[2], row[3], row[0])
        end
      end

      contacts
    end

    def all
      contacts = []

      sql = "SELECT * FROM numbers;"
      connection.exec(sql) do |response|
        response.values.each do |row|
          contacts << Number.new(row[1], row[2], row[3], row[0])
        end
      end

      contacts
    end

  end

end