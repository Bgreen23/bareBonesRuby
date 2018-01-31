require "cuba"
require "cuba/safe"
require "cuba/render"
require "erb"
require "sqlite3"


Cuba.use Rack::Session::Cookie, :secret => ENV["SESSION_SECRET"] || "__a_very_long_string__"

Cuba.plugin Cuba::Safe
Cuba.plugin Cuba::Render

db = SQLite3::Database.new "./db/dev.db"

Cuba.define do
  on root do
    anime_array = db.execute("SELECT * FROM animes")
    animes = anime_array.map do |id, name, creator, mainChar|
       { :id => id, :name => name, :creator => creator, :mainChar => mainChar }
    end
    p "animes", animes
    res.write view("index", animes: animes)
  end

  on "new" do
    res.write view("new")
  end

  on post do
    on "create" do
      name = req.params["name"]
      creator = req.params["creator"]
      mainChar = req.params["mainChar"]
      db.execute(
        "INSERT INTO animes (name, creator, mainChar) VALUES (?, ?, ?)",
        name, creator, mainChar
      )
      res.redirect "/"
    end

    on "delete/:id" do |id|
      db.execute(
        "DELETE FROM animes WHERE id=#{id}"
      )
      res.redirect "/"
    end
  end

  def not_found
    res.status = "404"
    res.headers["Content-Type"] = "text/html"

    res.write view("404")
  end
end
