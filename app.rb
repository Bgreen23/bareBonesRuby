require "cuba"
require "cuba/safe"
require "cuba/render"
require "erb"
require "sqlite3"
require_relative "./models/anime"

Cuba.use Rack::Session::Cookie, :secret => ENV["SESSION_SECRET"] || "__a_very_long_string__"

Cuba.plugin Cuba::Safe
Cuba.plugin Cuba::Render



Cuba.define do
  on root do
    anime = anime.all
    res.write view("index", animes: anime.all)
  end

  on "new" do
    res.write view("new")
  end
on get, "edit/:id" do |id|
  anime = db.execute(
    "SELECT * FROM animes WHERE id=?", id
  ).first
  pp 'anime as array', anime
  anime = OpenStruct.new(id: anime[0], name: anime[1], creator: anime[2], mainChar: anime[3] )
  res.write view("edit", anime: anime)
  pp 'anime as OpenStruct', anime
end

on post, "update/:id" do |id|
  db.execute(
    "UPDATE anime SET (name, creator, mainChar)=(?, ?, ?) WHERE id=?",
    req.params['name'],
    req.params['creator'],
    req.params['mainChar'],
    id,
  )
  res.redirect "/"
end

  on post, "create" do
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
