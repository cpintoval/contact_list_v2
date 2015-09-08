require 'pg'

class Contact

  # Instance Methods
  attr_accessor :firstname, :lastname, :email, :numbers
  attr_reader :id

  def initialize(firstname, lastname, email, numbers = {}, id = nil)
    @id = id
    @firstname = firstname
    @lastname = lastname
    @email = email
    @numbers = numbers
  end
 
  def to_s
    "#{@name} (#{email})"
  end

  def save
    if persisted?
      sql = "UPDATE contacts SET firstname = $1, lastname = $2, email = $3 WHERE id = #{id};"
      self.class.connection.exec_params(sql, [firstname, lastname, email])
    else
      sql = "INSERT INTO contacts (firstname, lastname, email) VALUES ($1, $2, $3) RETURNING id;"
      out = self.class.connection.exec_params(sql, [firstname, lastname, email])
      @id = out[0]['id'].to_i
    end
    true
  rescue
    false
  end

  def persisted?
    !id.nil?
  end

  def destroy
    sql = "DELETE FROM contacts WHERE id = $1;"
    self.class.connection.exec_params(sql, [id])
    self
  end
 
  ## Class Methods
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
      sql = "SELECT * FROM contacts WHERE id = $1;"
      connection.exec_params(sql, [id]) do |response|
        result = response.values[0]
        Contact.new(result[1], result[2], result[3], {}, result[0])
      end
    rescue
      nil
    end

    def find_all_by_lastname(name)
      contacts = []

      sql = "SELECT * FROM contacts WHERE lastname = $1;"
      connection.exec_params(sql, [name]) do |response|
        response.values.each do |row|
          contacts << Contact.new(row[1], row[2], row[3], {}, row[0])
        end
      end

      contacts
    end
    
    def find_all_by_firstname(name)
      contacts = []

      sql = "SELECT * FROM contacts WHERE firstname = $1;"
      connection.exec_params(sql, [name]) do |response|
        response.values.each do |row|
          contacts << Contact.new(row[1], row[2], row[3], {}, row[0])
        end
      end

      contacts
    end

    def find_by_email(email)
      sql = "SELECT * FROM contacts WHERE email = $1;"
      connection.exec_params(sql, [email]) do |response|
        result = response.values[0]
        Contact.new(result[1], result[2], result[3], {}, result[0])
      end
    rescue
      nil
    end

    def search(term)
      contacts = []

      sql = "SELECT * FROM contacts WHERE firstname LIKE '%#{term}%' OR lastname LIKE '%#{term}%' OR email LIKE '%#{term}%';"
      connection.exec(sql) do |response|
        response.values.each do |row|
          contacts << Contact.new(row[1], row[2], row[3], {}, row[0])
        end
      end

      contacts
    end

    def all
      contacts = []

      sql = "SELECT * FROM contacts;"
      connection.exec(sql) do |response|
        response.values.each do |row|
          contacts << Contact.new(row[1], row[2], row[3], {}, row[0])
        end
      end

      contacts
    end
    
  end
 
end