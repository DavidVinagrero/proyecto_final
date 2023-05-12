-- FASE 1
-- ESTE SCRIPT CREA UNA TABLA EXCEL CON LOS DATOS DE LA BD TAL Y COMO LOS OBTENDRIA SI EXPORTARAMOS A EXCEL LOS DATOS UN  MES 
-- HAY QUE EDITARLO Y CAMBIAR LAS FECHAS Y GUARDARLO ANTES DE EJECUTARLO
-- creo tabla nueva con los datos que se exportan
CREATE TABLE excel (
    id int(11) NOT NULL,
    name varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
    date datetime DEFAULT NULL,
    closedate datetime DEFAULT NULL,
    status int(11) NOT NULL DEFAULT '1',
    estado char(22) NOT NULL DEFAULT '1',
    priority int(11) NOT NULL DEFAULT '1',
    prioridad char(20) NOT NULL DEFAULT '1',
    actiontime int(11) NOT NULL DEFAULT '0',
    locations_id int(11) NOT NULL DEFAULT '0',
    ubicacion char(20) not null DEFAULT '0',
    idtecnico_asig int(11) NOT NULL DEFAULT '0',
    tecnico_asig char(50) NOT NULL DEFAULT '0',
    grupo_del_tecnico char(50) NOT NULL DEFAULT '0',
    idgrupo_asig int(11) NOT NULL DEFAULT '0',
    grupo_asig char(50) NOT NULL DEFAULT '0',
    tecnico_resolv char(70) NOT NULL DEFAULT '0',
    itilcategories_id int(11) NOT NULL DEFAULT '0',
    categoria char(150) NOT NULL DEFAULT '0',
    takeintoaccount_delay_stat int(11) NOT NULL DEFAULT '0',
    waiting_duration int(11) NOT NULL DEFAULT '0',
    duracion_tareas int(11) NOT NULL DEFAULT '0',
    date_mod datetime DEFAULT NULL,
    id_tipo int(11) NOT NULL DEFAULT '1',
    tipo char(20) NOT NULL DEFAULT '1'
);

-- insertamos las filas de este mes 
insert into
    excel (
        id,
        name,
        date,
        closedate,
        status,
        priority,
        actiontime,
        locations_id,
        itilcategories_id,
        takeintoaccount_delay_stat,
        waiting_duration,
        date_mod,
        id_tipo
    )
SELECT
    a.id,
    a.name,
    a.date,
    a.closedate,
    a.status,
    a.priority,
    a.actiontime,
    a.locations_id,
    a.itilcategories_id,
    a.takeintoaccount_delay_stat,
    a.waiting_duration,
    a.date_mod,
    a.type
FROM
    glpi_tickets a
    left join glpi_locations l on l.id = a.locations_id
where
    a.date between '2022-10-01 00:00:00'
    and '2022-10-31 23:59:59';

-- A�ADIMOS CLAVE PRIMARIA 
ALTER TABLE
    excel
ADD
    PRIMARY KEY (`id`);

-- CREAMOS TABLA AUXILIAR DE TOTAL 
create table total (total int(11) not null);

insert into
    total
select
    count(*)
from
    glpi_tickets
where
    date between '2022-10-01 00:00:00'
    and '2022-10-31 23:59:59';

-- CREAMOS TABLA AUXILIAR DE PRIORIDADES
create table priority (id_priority int(11) not null, descripcion text);

insert into
    priority (id_priority, descripcion)
values
    (1, 'Muy Baja');

insert into
    priority (id_priority, descripcion)
values
    (2, 'Baja');

insert into
    priority (id_priority, descripcion)
values
    (3, 'Mediana');

insert into
    priority (id_priority, descripcion)
values
    (4, 'Urgente');

insert into
    priority (id_priority, descripcion)
values
    (5, 'Muy Urgente');

insert into
    priority (id_priority, descripcion)
values
    (6, 'Mayor');

commit;

-- Creamos la tabla de Solicitud o Incidencia
create table tipos (id_tipo int(11) not null, descripcion text);

insert into
    tipos (id_tipo, descripcion)
values
    (1, 'Incidencia');

insert into
    tipos (id_tipo, descripcion)
values
    (2, 'Solicitud');

-- CREAMOS TABLA AUXILIAR DE ESTADOS DE INCIDENCIA
create table states (id_state int(11) not null, descripcion char(22));

insert into
    states(id_state, descripcion)
values
    (1, 'Nueva');

insert into
    states(id_state, descripcion)
values
    (2, 'En curso (asignada)');

insert into
    states(id_state, descripcion)
values
    (3, 'En curso (planificada)');

insert into
    states(id_state, descripcion)
values
    (4, 'En Espera');

insert into
    states(id_state, descripcion)
values
    (5, 'Resuelto');

insert into
    states(id_state, descripcion)
values
    (6, 'Cerrado');

-- CREAMOS LA TABLA AUXILIAR DE ANS1 PARA ACUERDO NIVEL DE SERVICIO 1 
create table ans1 (cantidad int(11) not null);

insert into
    ans1 (
        SELECT
            count(*)
        FROM
            excel
        where
            TIMESTAMPDIFF(minute, date, closedate) is not null
            and priority = 5
    );

-- CREAMOS LA TABLA AUXILIAR DE ANS1 PARA ACUERDO NIVEL DE SERVICIO 2 
create table ans2 (cantidad int(11) not null);

insert into
    ans2 (
        SELECT
            count(*)
        FROM
            excel
        where
            TIMESTAMPDIFF(minute, date, closedate) is not null
            and priority = 4
    );

-- ponemos la ubicacion
update
    excel,
    glpi_locations
set
    excel.ubicacion = glpi_locations.name
where
    excel.locations_id = glpi_locations.id;

-- ponemos el tipo
update
    excel,
    tipos
set
    excel.tipo = tipos.descripcion
where
    excel.id_tipo = tipos.id_tipo;

-- ponemos la prioridad
update
    excel,
    priority
set
    excel.prioridad = priority.descripcion
where
    excel.priority = priority.id_priority;

-- ponemos el estado
update
    excel,
    states
set
    excel.estado = states.descripcion
where
    excel.status = states.id_state;

-- ponemos las categorias
update
    excel,
    glpi_itilcategories
set
    excel.categoria = glpi_itilcategories.completename
where
    excel.itilcategories_id = glpi_itilcategories.id;

-- ponemos los tecnicos asignados
update
    excel,
    glpi_tickets_users
set
    excel.idtecnico_asig = glpi_tickets_users.users_id
where
    excel.id = glpi_tickets_users.tickets_id
    and glpi_tickets_users.type = 2;

update
    excel,
    glpi_users
set
    excel.tecnico_asig = Concat(glpi_users.realname, ' ', glpi_users.firstname)
where
    excel.idtecnico_asig = glpi_users.id;

-- ponemos el grupo al que pertenece el tecnico asignado
update
    excel,
    glpi_groups,
    glpi_groups_users
set
    excel.grupo_del_tecnico = glpi_groups.name
where
    excel.idtecnico_asig = glpi_groups_users.users_id
    and glpi_groups.id = glpi_groups_users.groups_id;

-- ponemos los grupos asignados
update
    excel,
    glpi_groups_tickets
set
    excel.idgrupo_asig = glpi_groups_tickets.groups_id
where
    excel.id = glpi_groups_tickets.tickets_id
    and glpi_groups_tickets.type = 2;

update
    excel,
    glpi_groups
set
    excel.grupo_asig = glpi_groups.name
where
    excel.idgrupo_asig = glpi_groups.id;

;

-- ponemos el tecnico que resuelve la incidencia
create table resolutores as
SELECT
    *
FROM
    glpi_logs log1
where
    new_value = '5'
    and date_mod between '2022-10-01 00:00:00'
    and '2022-10-31 23:59:59'
    and itemtype = 'Ticket'
    and id in (
        select
            max(id)
        from
            glpi_logs as log2
        where
            log1.items_id = log2.items_id
            and log2.new_value = '5'
            and log2.date_mod between '2022-10-01 00:00:00'
            and '2022-10-31 23:59:59'
            and log2.date_mod = log1.date_mod
    )
UNION
select
    *
FROM
    glpi_logs log3
where
    new_value = '6'
    and old_value = '5'
    and date_mod between '2022-10-01 00:00:00'
    and '2022-10-31 23:59:59'
    and itemtype = 'Ticket'
    and id in (
        select
            max(id)
        from
            glpi_logs as log4
        where
            log3.items_id = log4.items_id
            and log4.new_value = '6'
            and log4.date_mod between '2022-10-01 00:00:00'
            and '2022-10-31 23:59:59'
            and log4.date_mod = log3.date_mod
    )
order by
    items_id;

create table resolutores2 as
SELECT
    items_id,
    user_name
FROM
    resolutores
group by
    items_id,
    user_name;

update
    excel,
    resolutores2
set
    excel.tecnico_resolv = resolutores2.user_name
where
    resolutores2.items_id = excel.id;

update
    excel
set
    tecnico_resolv = tecnico_asig
where
    tecnico_resolv = '0';

-- ponemos los tiempo de tareas, previamente sumamos en la tabla auxiliar los de las incidencias que tienen mas de un tiempo
create table tiempo_tareas (
    id int(11) NOT NULL,
    tiempo int(11) NOT NULL DEFAULT '1'
);

insert into
    tiempo_tareas
select
    b.id,
    sum(a.actiontime)
from
    glpi_tickettasks a,
    glpi_tickets b
where
    b.date between '2022-10-01 00:00:00'
    and '2022-10-31 23:59:59'
    and b.id = a.tickets_id
group by
    a.tickets_id;

update
    excel,
    tiempo_tareas
set
    excel.duracion_tareas = tiempo_tareas.tiempo
where
    excel.id = tiempo_tareas.id;

;

drop table tiempo_tareas;

-- CREAMOS AHORA UNA TABLA A PARTIR DE ESTA PERO CON EL CAMPO ADICIONAL QUE LLAMAMOS ESCALADA
create table excel_escalada as
select
    *
from
    excel;

ALTER TABLE
    excel_escalada
ADD
    escalada char(1) default 'N';

ALTER TABLE
    excel_escalada
ADD
    PRIMARY KEY (`id`);

commit;

-- ponemos como escaladas aquellas que son de los grupos de escalada es decir INGESA MADRID, INGESA CEUTA, INGESA MELILLA
update
    excel_escalada,
    excel
set
    excel_escalada.escalada = 'S'
where
    excel_escalada.id = excel.id
    and excel.idgrupo_asig in (12, 13, 14);

-- FIN FASE 1, AHORA MANIPULAMOS A MANO EL FICHERO EXCEL_ESCALADA Y RELLENAMOS LO QUE FALTE A MANO
update
    excel,
    glpi_locations
set
    excel.ubicacion = glpi_locations.name
where
    excel.locations_id = glpi_locations.id