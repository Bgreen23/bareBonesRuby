class Anime
  attr_accessor :id, :name, :creator, :mainChar
  DB = SQLite3::Database.new "./db/dev.db"
  def initialize(id, name, creator, mainChar)
    @id = id
    @name = name
    @creator = creator
    @mainChar = mainChar
  end


    def self.all
      anime_array = DB.execute("SELECT * FROM animes")
      return animes = anime_array.map do |id, name, creator, mainChar|
      anime.new(:id => id,:name => name,:creator => creator, :mainChar => mainChar)
    end
  end
  def self.find(id)
  end
end
