create table storage(id serial primary key, title varchar, genre varchar, description varchar, director varchar, actors varchar, year decimal, runtime decimal, rating decimal, votes decimal, revenue decimal, metascore decimal);

create table movie (id integer primary key, title varchar, description varchar, runtime decimal, revenue decimal, review_id integer, director_id integer, time_id integer);

create table genre (id serial primary key, genre_name varchar);

create table actor (id serial primary key, actor_name varchar);

create table review (id integer primary key, votes decimal, metascore decimal, userscore decimal);

create table director (id serial primary key, director_name varchar);

create table time (id serial primary key, year decimal);

create table keywords (id serial primary key, word varchar);

alter table movie add constraint fk_review foreign key (review_id) references review(id);

alter table movie add constraint fk_director foreign key (director_id) references director(id);

alter table movie add constraint fk_time foreign key (time_id) references time(id);

create table hasgenre (movie_id integer, genre_id integer, primary key (movie_id, genre_id), foreign key (movie_id) references movie(id), foreign key (genre_id) references genre(id));

create table casting (movie_id integer, actor_id integer, primary key (movie_id, actor_id), foreign key (movie_id) references movie(id), foreign key (actor_id) references actor(id));

create table search (time_id integer, keyword_id integer, primary key (time_id, keyword_id), foreign key (time_id) references time(id), foreign key (keyword_id) references keywords(id));

\copy storage (id, title, genre, description, director, actors, year, runtime, rating, votes, revenue, metascore) from 'IMDB-Movie-Data.csv' with CSV HEADER;

insert into genre (genre_name) select distinct regexp_split_to_table(storage.genre, E',') from storage;

insert into actor (actor_name) select distinct regexp_split_to_table(storage.actors, E',') from storage;

insert into director (director_name) select distinct director from storage;

insert into time (year) values (2006), (2007), (2008), (2009), (2010), (2011), (2012), (2013), (2014), (2015), (2016);

insert into keywords (word) values ('highschool'), ('x-men'), ('angelina'), ('miley'), ('300'), ('joker'), ('batman'), ('twilight'), ('moon'), ('leo'), ('inception'), ('selena'), ('hunger'), ('avengers'), ('paul'), ('iron'), ('steel'), ('jared'), ('frozen'), ('sheen'), ('jurrasic'), ('compton'), ('brad'), ('suicide');

insert into review (id, votes, metascore, userscore) select storage.id, storage.votes, storage.metascore, storage.rating from storage;

insert into movie(id, title, description, runtime, revenue, review_id) select storage.id, storage.title, storage.description, storage.runtime, storage.revenue, storage.id from storage;

update movie m set time_id = t.id from storage as s join time as t on s.year = t.year where m.id = s.id;

update movie m set director_id = d.id from storage as s join director as d on s.director = d.director_name where m.id= s.id;

insert into search (time_id, keyword_id) values (1,1), (1,2), (1,3), (2,4), (2,1), (2,5), (3,4), (3,6), (3,7), (4,4),(4,8),(4,9),(5,4),(5,10),(5,11),(6,12),(6,8),(6,9),(7,4),(7,13),(7,14),(8,15),(8,16),(8,17),(9,18),(9,6),(9,19),(10,20),(10,21),(10,22),(11,23),(11,24),(11,6);

insert into casting select distinct c.id, a.id from (select s.id, regexp_split_to_table(s.actors, E',') as member from storage s) as c, movie m, actor a where c.id = m.id and a.actor_name = c.member;

insert into hasgenre select distinct c.id, g.id from (select s.id, regexp_split_to_table(s.genre, E',') as member from storage s) as c, movie m, genre g where c.id = m.id and g.genre_name = c.member;
