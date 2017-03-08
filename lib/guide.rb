require 'dogs.rb'

class Guide

  def initialize
    if Dog.file_usable?
      puts "Loading..."
    elsif Dog.create_file
      puts "I made a blank file, so fill it with dogs."
    else
      puts "Gotta go."
      exit!
    end
  end

  class AvailableActions
    @@actions = ['submit', 'rate', 'quit']
    def self.actions
      @@actions
    end
  end

  def launch!
    introduction
    result = nil
    until result == :quit
      action = get_action
      result = do_action(action)
    end
    conclusion
  end

  def get_action
    print "> "
    action = gets.chomp.downcase
    if !Guide::AvailableActions.actions.include?(action)
      puts "Here's what you can do: " + Guide::AvailableActions.actions.join(", ")
    else
      return action
    end
  end

  def do_action(action)
    case action
    when 'submit'
      submit_intro_text
      submit_your_dog
      save_dog
    when 'rate'
      rate_dog
    when 'quit'
      return :quit
    end
  end

  def submit_your_dog
    print "> "
    get_url = gets.chomp.downcase
    puts "Now you wouldn't lie to me."
    puts "That's actually a dog pic, right?"
    trust_loop
    @get_url = get_url
  end

  def save_dog
    dog_file = File.read('dogs.json').split("\n")
    doggos = dog_file.map do |dog|
      url, color, breed, name, rating = dog.to_s.split("\t")
      Dog.new(url, color, breed, name, rating)
    end
    if doggos.any? {|dog| dog.url == @get_url}
        puts "Hey I know that dog. Pat pat pat."
        puts "But in case you're wondering, here's a review:"
        rand_review
        # this still needs to return the rating for the dog.
      else
        write_to_file
      end
  end

  def submit_intro_text
    puts "Okay. I want to see that dog. Copy in a URL."
    puts "And don't lie to me. My feelings get hurt easily."
  end

  def generate_rating
    "#{rand(10..15)}/10"
  end

  def write_to_file
    puts "What a cutie!"
    puts "I want to know more. What's his/her:"
    puts "Color?"
    print "> "
    color = gets.chomp.downcase
    puts "Breed?"
    print "> "
    breed = gets.chomp.downcase
    puts "Name? (You can make one up if you don't know.)"
    print "> "
    name = gets.chomp.downcase
    rating = generate_rating
    dog_file = File.open('dogs.json' , 'a')
    dog_file << "\n#{@get_url}\t#{color}\t#{breed}\t#{name}\t#{rating}"
    dog_file.close
    puts "I will remember that dog forever."
  end

  def trust_loop
    print "> "
    trust_response = gets.chomp.downcase
    case trust_response
    when "yes"
      return "yes"
    when "no"
      puts "I trusted you. Copy in another link. This time with a dog.\n"
      submit_your_dog
    else
      puts "I'm only listening if you say yes or no."
      trust_loop
    end
  end

  def rate_dog
# rate a "random" dog from the dogs.json file
    dog_file = File.read('dogs.json').split("\n")
    each_dog = dog_file.map do |dog|
      url, color, breed, name, rating = dog.to_s.split("\t")
      Dog.new(url, color, breed, name, rating)
    end
    puts "What do you think of this dog?"
    @rand_dog = each_dog.sample
    puts @rand_dog.url
    puts "I'm told s/he is a #{@rand_dog.color} #{@rand_dog.breed.capitalize} named #{@rand_dog.name.capitalize}."
    user_rating
    user_review
    puts "Your review for #{@rand_dog.name.capitalize} is: "
    puts "#{@user_rev}. #{@final_rating}"
    puts "\n\n\n...\n\n\n"
    puts "Are you kidding?"
    puts "I could write a better review than that at random. Watch.\n\n"
    rand_review
    abs_sass
  end

@@counter = 0

  def abs_sass
    puts "\nNow do you agree that dog rating should be left to Professional Dog Raters™?"
    print "> "
    sass_answer = gets.chomp
    if sass_answer == "yes" || sass_answer == "yeah" #because steven is so casual about affirmation
      puts "As you should."
      puts "Now go submit a dog or something."
    elsif sass_answer == "no" || sass_answer == "nope" #because steven again
      until @@counter == 5 do
        puts "Fine, have another review."
        @@counter += 1
        puts "Counter is at #{@@counter}."
        rand_review
        abs_sass
      end
    else
        puts "It's a yes or no question."
        abs_sass
    end
  end

  def user_rating
    puts "Go ahead. Rate #{@rand_dog.name.capitalize} on a 10 point scale."
    print "> "
    user_rate = Integer(gets) rescue false
    if user_rate.is_a? Integer
      if user_rate < 10
        puts "The dogs are better than that."
        user_rating
      else
        @final_rating = "#{user_rate}/10"
      end
    else
      puts "That's not a number that I understand."
      user_rating
    end
  end

  def user_review
    puts "Now write your own review. Go ahead. I'll wait."
    print "> "
    @user_rev = gets.chomp
  end

  def rand_adv
    adv = ["lovingly" , "softly" , "happily" , "well" , "warmly" , "fiercely" , "passionately"]
    adv.sample
  end

  def rand_adj
    adj = ["soft" , "pettable" , "boopable" , "warm" , "cute" , "sweet" , "snuggable" , "pettable af"]
    adj.sample
  end

  def rand_verb
    verb = ["boop" , "pet" , "snug" , "hug" , "love" , "cuddle" , "kill for" , "boop that schnoop"]
    verb.sample
  end

  def dog_or_pup
    dog_or_pup = ["doggo" , "pupper" , "pupperoo" , "pupperoni" , "benepup cumberflop"]
    dog_or_pup.sample
  end

  def rand_review
    puts "What a #{rand_adj} #{dog_or_pup}! Would #{rand_verb} #{rand_adv}. #{generate_rating}"
  end

  def introduction
    puts "\nWelcome to the first professional Dog Rater™.\n"
    puts "Brought to you by the biggest fans of doggos: @samsymons, @superdealloc, @deancommasteven and @michaelulrich.\n"
    puts "Here's what you can do:"
    puts "- Type 'submit' to give me a dog to rate."
    puts "- Type 'rate' if you think you have the chops to rate a dog."
    puts "- Type 'quit' if you're a chicken."
  end

  def conclusion
    puts "Wait, you want to leave?\n"
    puts "You understand the dogs are good, right?\n"
    print "> "
    conclusion_input = gets.chomp.downcase
    if conclusion_input == "yes" || conclusion_input == "right"
      puts "\nOkay then. Our work is done.\n\n"
    elsif conclusion_input == "no" || conclusion_input == "wrong"
      puts "Let's try again then."
      launch!
    else
      puts "I didn't understand that, so I'm going to ask again."
      conclusion
    end
  end

end
