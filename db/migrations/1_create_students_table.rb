require "sqlite3"

db = SQLite3::Database.new "./db/dev.db"

db.execute "
  create table animes (
    id INTEGER PRIMARY KEY ASC,
    name VARCHAR(255),
    creator VARCHAR(255),
    mainChar VARCHAR(255)
  );
"

anime = [
  ["My Hero Academia", " Kohei Horikoshi", "Deku"],
]

anime.each do |anime|
  db.execute(
    "INSERT INTO animes (name, creator, mainChar) VALUES (?, ?, ?)", anime
  )
end
