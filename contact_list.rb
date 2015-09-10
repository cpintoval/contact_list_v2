#!/usr/bin/env ruby
require_relative 'setup'

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
          contact = Contact.create(firstname: firstname, lastname: lastname, email: email)
          puts "New contact created with id: #{contact.id}"
          puts "Add phone numbers (yes/no)?"
          cmd = $stdin.gets.chomp
          if cmd.downcase == "yes"
            numbers = {}
            while true
              puts "Enter tag for the phone number: "
              tag = $stdin.gets.chomp
              puts "Enter phone number: "
              number = $stdin.gets.chomp
              new_number = contact.numbers.create(tag: tag, number: number)
              puts "Number added with id: #{new_number.id}"
              puts "Add another one? (yes/no)"
              cmd = $stdin.gets.chomp
              if cmd.downcase == "no"
                break
              end
            end
          end
        else
          puts "Contact already exists in the database"
        end
      when 'list'
        list = Contact.all
        if list.length != 0
          list.each do |contact|
            output = "#{contact.id}: #{contact.firstname} #{contact.lastname} (#{contact.email})"
            numbers = Number.find_all_by_contactid(contact.id)
            numbers.each do |number|
              output += " - #{number.tag}: #{number.number}"
            end
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
            # numbers = Number.find_all_by_contactid(contact.id)
            # numbers.each do |number|
            #   puts "#{number.tag}: #{number.number}"
            # end
          else
            puts "Not found"
          end
        else
          puts "Need to specify id to show"
        end
      # when 'search'
      #   term = ARGV[1]
      #   if !term.nil? && !term.empty?
      #     result = Contact.search(term)
      #     if result != []
      #       result.each do |contact|
      #         puts "Name: #{contact.firstname} #{contact.lastname}"
      #         puts "Email: #{contact.email}"
      #         numbers = Number.find_all_by_contactid(contact.id)
      #         numbers.each do |number|
      #           puts "#{number.tag}: #{number.number}"
      #         end
      #         puts "----------------------------------------------"
      #       end
      #     else
      #       puts "Not found"
      #     end
      #   else
      #     puts "Need to specify term to search"
      #   end
      end
    else
      puts "Run 'help' to see the available commands"
    end
  end

end

# Creation of an Application instance and running it
Application.run