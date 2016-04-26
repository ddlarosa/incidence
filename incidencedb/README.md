# RMXdb

RMXdb es el componente de acceso a base de datos común al sistema RMX.
Está basado en la Ruby Gem `sequel` y se utiliza desde los dos
servidores del sistema: RMXserv y RMXpanel.

Se compone de dos directorios:

- migrations: descripción incremental de las tablas de la base de
  datos.

- model: clases que abstraen el acceso a base de datos según
  metodologías de orientación a objetos.


## Instalación de dependencias

El sistema operativo aconsejado es Debian 7.0 Wheezy o Ubuntu 12.04
LTS Precise Pangolin (o posterior). Deben instalarse los siguientes
paquetes, y sus dependencias:

- `ruby1.9.1-full`
- `postgresql-9.1`
- `libpq-dev`
- `libxml2-dev`
- `libxslt1-dev`
- `redis-server`

A continuación se instalará el gestor de dependencias de paquetes
Ruby:

    sudo gem install bundler

Y seguidamente se instalarán las librerías Ruby necesarias ejecutando
el siguiente comando desde la raiz de cada uno de los directorios de
los servidores Ruby del sistema RMX (rmxserv y rmxpanel):

    bundle install


## Creación de base de datos


Añadir la siguiente linea como primera entrada en el fichero
`/etc/postgresql/9.1/main/pg_hba.conf`, para permitir al usuario rmx
de la base de datos el acceso sin contraseña desde la propia máquina.

    host    rmx    rmx    127.0.0.1/32    trust

Ejecutar las siguientes instrucciones para crear la base de datos y el
usuario rmx:

    su - postgres
    createdb rmx
    createuser rmx    # (responder no a todo)


## Procedimientos útiles

A continuación se describen algunos procedimientos útiles de
manipulación de la base de datos. No son necesarios para poner en
marcha el sistema RMX.

### Crear estructura de tablas de la base de datos

No es necesario, porque al lanzar cualquiera de los servidores
(rmxserv/rmxpanel) se ejecutan las migrations que haya pendientes, con
lo que se crea/actualiza automáticamente la estructura de tablas de la
base de datos.

    sequel -E -m migrations/ postgres://rmx@localhost/rmx

### Borrar tablas de la base de datos

Se pueden deshacer migrations manualmente. Si se ordena establecer la
migration 0, se borran las tablas de la base de datos.

    sequel -E -M 0 -m migrations/ postgres://incidence@localhost/incidence

### Acceder a la base de datos mediante la shell interactiva de PostgreSQL

La herramienta psql permite revisar y manipular la base de datos
mediante comandos SQL.

    psql -U rmx -h localhost rmx

### Eliminar las referencias a canciones no existentes

Si en un entorno de test no se dispone del fondo musical al completo,
puede ser interesante eliminar las referencias en las playlists a
canciones no disponibles tras cargas las playlists.

    rmxploader ...  # cargar playlists
    rmxsloader      # registrar la existencia de ficheros de canciones
    echo "delete from songs_in_playlists where song_id in (select id from songs where file_exists='false');" | psql -U rmx -h localhost rmx
                    # eliminar las referencias a canciones no existentes
    rmxsloader      # actualiza el campo ready de las playlists sin tener ya ficheros inexistentes

### Acceder a la base de datos mediante la shell interactiva de Ruby

Se puede utilizar la shell interactiva de ruby para revisar/manipular
la base de datos utilizando la librería sequel.

    irb -I model -r init

### Volcar el esquema actual de la base de datos a formato migration

Tras un número de migrations aplicadas, es incómodo repasar uno a uno
los ficheros de migrations para revisar el estado actual de la base de
datos. Volcando el schema obtenemos una nueva migration aglutinadora
de todas las aplicadas:

    sequel -d postgres://rmx@localhost/rmx
