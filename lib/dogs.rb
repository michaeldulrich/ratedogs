class Dog
# more like classy dogs amirite

  def initialize(url, color, breed, name, rating)
    @url = url
    @color = color
    @breed = breed
    @name = name
    @rating = rating
  end

  @@filepath = File.join(APP_ROOT, 'dogs.json')

  attr_accessor :url, :color, :breed, :name, :rating

  def self.file_usable?
    return false unless @@filepath
    return false unless File.exist?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end

  def self.create_file
    File.open('dogs.json', 'w') unless File.exist?(@@filepath)
    return file_usable?
  end

  def self.saved_dogs
    dogs = []
    if file_usable?
      file = File.open('dogs.json' , 'r')
      file.each_line do |line|
        dogs << Dog.new.import_line(line.chomp)
      end
      file.close
    end
    return dogs
  end

end
