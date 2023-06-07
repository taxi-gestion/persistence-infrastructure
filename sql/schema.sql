DROP TABLE IF EXISTS fares;
CREATE TABLE fares (
  client TEXT NOT NULL,
  creator TEXT NOT NULL,
  date TEXT NOT NULL,
  departure TEXT NOT NULL,
  destination TEXT NOT NULL,
  distance NUMERIC NOT NULL,
  driver TEXT NOT NULL,
  duration NUMERIC NOT NULL,
  kind TEXT NOT NULL,
  nature TEXT NOT NULL,
  phone TEXT NOT NULL,
  status TEXT NOT NULL,
  time TEXT NOT NULL
);
