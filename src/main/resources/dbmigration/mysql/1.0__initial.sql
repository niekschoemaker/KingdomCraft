-- apply changes
create table kingdom (
  id                            bigint auto_increment not null,
  name                          varchar(255) not null,
  display                       varchar(255),
  prefix                        varchar(255),
  suffix                        varchar(255),
  spawn                         varchar(255),
  invite_only                   integer default 0 not null,
  default_rank_id               bigint,
  created_at                    datetime(6) not null,
  constraint uq_kingdom_name unique (name),
  constraint uq_kingdom_default_rank_id unique (default_rank_id),
  constraint pk_kingdom primary key (id)
);

create table kingdom_invite (
  kingdom_id                    bigint,
  sender_id                     varchar(255),
  target_id                     varchar(255),
  created_at                    datetime(6) not null,
  constraint uq_kingdom_invite_kingdom_id unique (kingdom_id),
  constraint uq_kingdom_invite_sender_id unique (sender_id),
  constraint uq_kingdom_invite_target_id unique (target_id)
);

create table kingdom_relation (
  kingdom_id                    bigint,
  target_id                     bigint,
  relation                      integer not null,
  created_at                    datetime(6) not null,
  constraint uq_kingdom_relation_kingdom_id unique (kingdom_id),
  constraint uq_kingdom_relation_target_id unique (target_id),
  constraint uq_kingdom_relation_kingdom_id_target_id unique (kingdom_id,target_id)
);

create table player (
  id                            varchar(255) not null,
  name                          varchar(255) not null,
  kingdom_id                    bigint,
  rank_id                       bigint,
  created_at                    datetime(6) not null,
  constraint uq_player_name unique (name),
  constraint pk_player primary key (id)
);

create table rank (
  id                            bigint auto_increment not null,
  kingdom_id                    bigint,
  name                          varchar(255) not null,
  display                       varchar(255),
  prefix                        varchar(255),
  suffix                        varchar(255),
  created_at                    datetime(6) not null,
  constraint uq_rank_kingdom_id_name unique (kingdom_id,name),
  constraint pk_rank primary key (id)
);

alter table kingdom add constraint fk_kingdom_default_rank_id foreign key (default_rank_id) references rank (id) on delete restrict on update restrict;

alter table kingdom_invite add constraint fk_kingdom_invite_kingdom_id foreign key (kingdom_id) references kingdom (id) on delete restrict on update restrict;

alter table kingdom_invite add constraint fk_kingdom_invite_sender_id foreign key (sender_id) references player (id) on delete restrict on update restrict;

alter table kingdom_invite add constraint fk_kingdom_invite_target_id foreign key (target_id) references player (id) on delete restrict on update restrict;

alter table kingdom_relation add constraint fk_kingdom_relation_kingdom_id foreign key (kingdom_id) references kingdom (id) on delete restrict on update restrict;

alter table kingdom_relation add constraint fk_kingdom_relation_target_id foreign key (target_id) references kingdom (id) on delete restrict on update restrict;

create index ix_player_kingdom_id on player (kingdom_id);
alter table player add constraint fk_player_kingdom_id foreign key (kingdom_id) references kingdom (id) on delete restrict on update restrict;

create index ix_player_rank_id on player (rank_id);
alter table player add constraint fk_player_rank_id foreign key (rank_id) references rank (id) on delete restrict on update restrict;

create index ix_rank_kingdom_id on rank (kingdom_id);
alter table rank add constraint fk_rank_kingdom_id foreign key (kingdom_id) references kingdom (id) on delete restrict on update restrict;

