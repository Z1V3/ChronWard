drop table if exists evchargeschema.users cascade;
create table evchargeschema.users
(
    user_id  serial
        primary key,
    username varchar(50) not null,
    email    varchar(50) not null
        constraint unique_email
            unique,
    password varchar(30) not null,
    active   boolean     not null,
    created  timestamp   not null,
    role     varchar(30) not null
);

drop table if exists evchargeschema.charger cascade;
create table evchargeschema.charger
(
    charger_id serial
        primary key,
    name       varchar(50)   not null,
    latitude   numeric(9, 6) not null,
    longitude  numeric(9, 6) not null,
    created    timestamp     not null,
    creator    integer       not null
        constraint user_user_id_fk
            references evchargeschema.users,
    lastsync   timestamp     not null
);

drop table if exists evchargeschema.event cascade;
create table evchargeschema.event
(
    event_id   serial
        primary key,
    charger_id integer        not null
        constraint charger_charger_id_fk
            references evchargeschema.charger,
    starttime  timestamp      not null,
    endtime    timestamp      not null,
    volume     numeric(10, 1) not null,
    user_id    integer        not null
        constraint user_user_id_fk
            references evchargeschema.users
);


drop table if exists evchargeschema.card cascade;
create table evchargeschema.card
(
    card_id serial
        primary key,
    user_id integer        not null
        constraint user_user_id_fk
            references evchargeschema.users,
    value   integer 	   not null,
    active  boolean        not null
);

