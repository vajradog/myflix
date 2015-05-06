# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(
	title: "Spirited Away", 
	description: "In this animated feature by noted Japanese director Hayao Miyazaki, 10-year-old Chihiro (Rumi Hiiragi) and her parents (Takashi Naitô, Yasuko Sawaguchi) stumble upon a seemingly abandoned amusement park. After her mother and father are turned into giant pigs.",
	small_cover_url: "spirited_away.jpg",
	large_cover_url: "/spirited_away_large.jpg" )


Video.create(
	title: "My Neighbor Totoro", 
	description: "Two sisters encounter a mythical forest sprite and its woodland companions when they move to rural Japan.",
	small_cover_url: "totoro.jpg",
	large_cover_url: "totoro_large.jpg" )

Video.create(
	title: "Ponyo", 
	description: "During a forbidden excursion to the surface world, a goldfish princess (Yuria Nara) becomes more and more human after befriending a village boy.",
	small_cover_url: "ponyo.jpg",
	large_cover_url: "large_ponyo.jpg" )

Video.create(
	title: "Mononoke", 
	description: "A prince becomes involved in the struggle between a forest princess and the encroachment of mechanization.",
	small_cover_url: "mononoke.jpg",
	large_cover_url: "large_mononoke.jpg" )

Video.create(
	title: "Porco Rosso", 
	description: "In Italy in the 1930s, sky pirates in biplanes terrorize wealthy cruise ships as they sail the Adriatic Sea. The only pilot brave enough to stop the scourge is the mysterious Porco Rosso (Shuichiro Moriyama), a former World War I flying ace who was somehow turned into a pig during the war.",
	small_cover_url: "rosso.jpg",
	large_cover_url: "large_rosso.jpg" )