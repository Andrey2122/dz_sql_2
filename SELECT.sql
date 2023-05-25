-- Количество исполнителей в каждом жанре.
select genre_name, count(squad_id) from public.genre g
join squad_genre s on s.genre_id = g.genre_id  
group by genre_name;

-- Количество треков, вошедших в альбомы 2019–2020 годов.
select count(album_name) from public.songs s
join public.album a on a.album_id = s.album_id 
where a.year_of >= 2019 and a.year_of <= 2020;

-- Средняя продолжительность треков по каждому альбому.
select album_name, avg(duration) from public.songs s 
join public.album a on a.album_id = s.album_id 
group by album_name;

-- Все исполнители, которые не выпустили альбомы в 2020 году.
select squad_name from squad
where squad_name not in (select squad_name from squad
join  squad_album sa on sa.squad_id = squad.squad_id 
join public.album on sa.album_id = public.album.album_id 
where public.album.year_of = '2020');

--Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
select collection_name from collection
join songcollection on songcollection.collection_id = collection.collection_id 
join songs on songcollection.song_id = songs.songs_id 
join album on songs.album_id = album.album_id 
join squad_album on squad_album.album_id = album.album_id
join public.squad on squad_album.squad_id = squad.squad_id 
where squad_name = 'musician_2'
group by collection_name

--Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
select distinct  album_name from album
join squad_album on squad_album.album_id = album.album_id
join squad on squad_album.squad_id = squad.squad_id 
join squad_genre on squad.squad_id = squad_genre.squad_id 
group by album_name, squad_album.squad_id
having count(public.squad_album.squad_id) > 1;

--Наименования треков, которые не входят в сборники.
select songs_name from songs
left join songcollection on songs.songs_id = songcollection.song_id 
where collection_id is null;

-- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
select squad_name, duration from songs
join album on songs.album_id = album.album_id 
join squad_album on album.album_id  = squad_album.album_id 
join squad on squad_album.squad_id = squad.squad_id 
where duration = (select min(duration) from songs);

--Названия альбомов, содержащих наименьшее количество треков.
select album_name from album
join songs on songs.album_id = album.album_id 
group by album_name
having count(songs_name) = (select count(songs_id) from songs
group by songs.album_id
order by 1
limit 1)