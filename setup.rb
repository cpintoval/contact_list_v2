require 'pry'
require 'active_record'
require_relative 'lib/contact'
require_relative 'lib/number'

ActiveRecord::Base.logger = Logger.new(STDOUT)

puts 'Establishing connection to database ...'
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'contactsdb',
  username: 'development',
  password: 'development',
  host: 'localhost',
  port: 5432,
  pool: 5,
  encoding: 'unicode',
  min_messages: 'error'
)
puts 'CONNECTED'

puts 'Setting up Database (recreating tables) ...'
ActiveRecord::Schema.define do
  drop_table :contacts if ActiveRecord::Base.connection.table_exists?(:contacts)
  drop_table :numbers if ActiveRecord::Base.connection.table_exists?(:numbers)

  create_table :contacts do |t|
    t.column :firstname, :string
    t.column :lastname, :string
    t.column :email, :string
    t.timestamps null: false
  end

  create_table :numbers do |t|
    t.references :contact
    t.column :tag, :string
    t.column :number, :string
    t.timestamps null: false
  end
end

puts 'Setup DONE'