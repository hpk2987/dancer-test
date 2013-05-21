USE 'mydb';

CREATE user 'prueba'@'localhost' IDENTIFIED BY 'prueba';
GRANT SELECT,INSERT,UPDATE,DELETE on mydb.* TO 'prueba'@'localhost';
