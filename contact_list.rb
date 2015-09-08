#!/usr/bin/env ruby
require_relative 'contact'

# TODO: Implement command line interaction
# This should be the only file where you use puts and gets
class Application

  # Main method to run the app
  def self.run
    
    if !ARGV.empty?
      arg = ARGV[0]
      case arg
      when 'help'
        puts "Here is a list of available commands:"
        puts "    new  - Create a new contact"
        puts "    list - List all contacts"
        puts "    find - Find a contact by ID"
        puts "    search - Search a contact by text"
      when 'new'
        puts "Enter contact's email: "
        email = $stdin.gets.chomp
        if Contact.find_by_email(email) == nil
          puts "Enter contact's first name: "
          firstname = $stdin.gets.chomp
          puts "Enter contact's last name: "
          lastname = $stdin.gets.chomp
          puts "Add phone numbers (yes/no)?"
          cmd = $stdin.gets.chomp
          if cmd.downcase == "yes"
            numbers = {}
            while true
              puts "Enter label for the phone number: "
              label = $stdin.gets.chomp
              puts "Enter phone number: "
              number = $stdin.gets.chomp
              numbers[label] = number
              puts "Add another one? (yes/no)"
              cmd = $stdin.gets.chomp
              if cmd.downcase == "no"
                break
              end
            end
            contact = Contact.new(firstname, lastname, email, numbers)
            contact.save
            puts "New contact created with id: #{contact.id}"
          else
            contact = Contact.new(firstname, lastname, email)
            contact.save
            puts "New contact created with id: #{contact.id}"
          end
        else
          puts "Contact already exists in the database"
        end
      when 'list'
        list = Contact.all
        if list.length != 0
          list.each do |contact|
            output = "#{contact.id}: #{contact.firstname} #{contact.lastname} (#{contact.email})"
            # i = 3
            # while item[i] != nil
            #   arr = item[i].split(":")
            #   output += " - #{arr[0].capitalize}: #{arr[1]}"
            #   i += 1
            # end
            puts output
          end
          puts "---"
          puts "#{list.length} records total"
        else
          puts "No contacts stored in database"
        end
      when 'find'
        id = ARGV[1]
        if !id.nil? && !id.empty?
          contact = Contact.find(id.to_i)
          if contact != nil
            puts "Name: #{contact.firstname} #{contact.lastname}"
            puts "Email: #{contact.email}"
            # i = 3
            # while result[i] != nil
            #   arr = result[i].split(":")
            #   puts "#{arr[0].capitalize}: #{arr[1]}"
            #   i += 1
            # end
          else
            puts "Not found"
          end
        else
          puts "Need to specify id to show"
        end
      when 'search'
        term = ARGV[1]
        if !term.nil? && !term.empty?
          result = Contact.search(term)
          if result != []
            result.each do |contact|
              puts "Name: #{contact.firstname} #{contact.lastname}"
              puts "Email: #{contact.email}"
              puts "----------------------------------------------"
            end
          else
            puts "Not found"
          end
        else
          puts "Need to specify term to search"
        end
      end
    else
      puts "Run 'help' to see the available commands"
    end
  end

end

# Creation of an Application instance and running it
Application.run