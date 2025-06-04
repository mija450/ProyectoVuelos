/*
private user = root;
private host = localhost;
private password = ;
private name = flight_booking;
*/

select*from flights;
select*from reservations;
select*from users;
select*from airports;
select*from airlines;
select*from baggage;
select*from airports;
select*from airlines;
select*from baggage;
select*from flight_history;

CREATE TABLE flights (
  id int(11) NOT NULL,
  flight_number varchar(50) NOT NULL,
  departure_airport_id int(11) NOT NULL, 
  arrival_airport_id int(11) NOT NULL,
  departure_time datetime NOT NULL,
  arrival_time datetime NOT NULL,
  price decimal(10,2) NOT NULL,
  seats_available int(11) NOT NULL,
  airline_id int(11) DEFAULT NULL -- Relacionado con aerolíneas
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO flights (id, flight_number, departure_airport_id, arrival_airport_id, departure_time, arrival_time, price, seats_available, airline_id) VALUES
(1, 'AB123', 1, 2, '2024-10-01 08:00:00', '2024-10-01 11:00:00', 250.00, 47, 10),
(2, 'CD456', 3, 4, '2024-10-02 12:00:00', '2024-10-02 14:00:00', 180.00, 72, 5),
(3, 'EF789', 5, 6, '2024-10-03 09:00:00', '2024-10-03 11:30:00', 120.00, 99, 7),
(4, 'GH012', 7, 8, '2024-10-04 07:00:00', '2024-10-04 10:15:00', 300.00, 20, 1),
(5, 'IJ345', 9, 10, '2024-10-05 14:00:00', '2024-10-05 18:00:00', 230.00, 60, 4);

CREATE TABLE reservations (
  id int(11) NOT NULL,
  user_id int(11) DEFAULT NULL,
  flight_id int(11) DEFAULT NULL,
  booking_date datetime DEFAULT current_timestamp(),
  status enum('confirmed', 'cancelled') DEFAULT 'confirmed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO reservations (id, user_id, flight_id, booking_date, status) VALUES
(1, 1, 1, '2024-09-20 15:30:00', 'confirmed'),
(2, 2, 2, '2024-09-21 16:00:00', 'confirmed'),
(3, 1, 3, '2024-09-22 14:30:00', 'confirmed'),
(4, 3, 4, '2024-09-23 10:00:00', 'cancelled'),
(5, 4, 5, '2024-09-24 18:15:00', 'confirmed'),
(6, 6, 1, '2024-09-23 22:19:10', 'confirmed'),
(7, 4, 2, '2024-09-23 22:19:57', 'confirmed'),
(8, 5, 2, '2024-09-23 22:38:24', 'confirmed'),
(9, 7, 1, '2024-09-23 23:43:02', 'confirmed'),
(10, 10, 1, '2024-09-23 23:58:56', 'confirmed'),
(11, 9, 2, '2024-09-23 23:59:41', 'cancelled'),
(12, 8, 3, '2024-09-23 23:59:50', 'confirmed');

CREATE TABLE users (
  id int(11) NOT NULL,
  name varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  password varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO users (id, name, email, password) VALUES
(1, 'Ryan Gosling', 'ryan@gmail.com', '12345'),
(2, 'Johnny Depp', 'john@hotmail.com', '2468'),
(3, 'John Patrick Amedori', 'jpa@yahoo.es', '9856'),
(4, 'Tom Atkins', 'tom@gmail.com', '98765'),
(5, 'Dayana Anderson', 'daya@gmail.com', '4527'),
(6, 'Victor Aaron Centeno', 'victor@gmail.com', 'victor123'),
(7, 'Marshall Allen', 'allen@yahoo.es', 'allen123'),
(8, 'Judie Aronson', 'judi@gmail.com', 'judie246'),
(9, 'Rossy Lynch', 'rossy@gmail.com', 'rossy123'),
(10, 'Margarita Torres Urrutia', 'rossy@gmail.com', 'rossy123');

CREATE TABLE airports (
  id int(11) NOT NULL,
  name varchar(255) NOT NULL,
  city varchar(100) NOT NULL,
  country varchar(100) NOT NULL,
  code varchar(10) NOT NULL -- Código IATA o ICAO
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO airports (id, name, city, country, code) VALUES
(1, 'Aeropuerto Internacional Midway', 'Chicago', 'Estados Unidos', 'ORD'),
(2, 'Aeropuerto Internacional de Indianápolis', 'Indianápolis', 'Estados Unidos', 'KIND'),
(3, 'Aeropuerto Forbes Field', 'Topeka', 'Estados Unidos', 'KFOE'),
(4, 'Aeropuerto Blue Grass', 'Lexington', 'Estados Unidos', 'KLEX'),
(5, 'Aeropuerto Internacional de Alexandria', 'Alejandría', 'Estados Unidos', 'KAEX'),
(6, 'Aeropuerto Internacional de Sao Paulo-Guarulhos', 'Sao Paulo', 'Brasil', 'GRU'),
(7, 'Aeropuerto Internacional Jorge Chávez', 'Lima', 'Perú', 'LIM'),
(8, 'Aeropuerto Internacional de Ciudad Juárez', 'Juárez', 'Mexico', 'MEX'),
(9, 'Aeropuerto Internacional de Aguas calientes', 'Aguas Calientes', 'Mexico', 'MEX'),
(10, 'Aeropuerto Internacional Ministro Pistarini', 'Buenos Aires', 'Argentina', 'EZE');

CREATE TABLE airlines (
  id int(11) NOT NULL,
  name varchar(255) NOT NULL,
  country varchar(100) NOT NULL,
  logo varchar(255) DEFAULT NULL -- URL para el logo de la aerolínea
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO airlines (id, name, country, logo) VALUES
(1, 'American Airlines', 'Estados Unidos', 'American'),
(2, 'JetBlue Airways', 'Estados Unidos', 'SOUTHWEST'),
(3, 'Avianca', 'Perú', 'A'),
(4, 'SKY Airlines', 'Perú', 'SKY'),
(5, 'LATAM Airlines', 'Brasil', 'LATAM'),
(6, 'Volaris Airlines', 'Mexico', 'Plane'),
(7, 'Aeromexico', 'Mexico', 'Plane'),
(8, 'American Jet', 'Argentina', 'Plane'),
(9, 'Jet SMART', 'Argentina', 'JET'),
(10, 'Delta Airlines', 'Estados Unidos', 'Triangle');

CREATE TABLE baggage (
  id int(11) NOT NULL,
  reservation_id int(11) NOT NULL,
  weight decimal(5,2) NOT NULL,
  type enum('carry-on','checked') DEFAULT 'checked'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE flight_history (
  id int(11) NOT NULL,
  flight_id int(11) NOT NULL,
  status enum('scheduled','delayed','cancelled','completed') NOT NULL,
  change_time datetime NOT NULL,
  reason varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE HistorialVuelo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_vuelo VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    cambio_hora DATETIME NOT NULL,
    razon TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO HistorialVuelo (codigo_vuelo, estado, cambio_hora, razon) VALUES 
('AA123', 'Cancelado', '2023-10-10 15:30:00', 'Condiciones climáticas'),
('BA456', 'Retrasado', '2023-10-11 09:15:00', 'Problemas técnicos'),
('UA789', 'En hora', '2023-10-12 12:00:00', 'Vuelo programado a tiempo'),
('DL101', 'Cancelado', '2023-10-13 18:45:00', 'Huelga de personal'),
('SW102', 'Retrasado', '2023-10-14 14:30:00', 'Condiciones meteorológicas adversas'),
('AC103', 'En hora', '2023-10-15 08:00:00', 'Vuelo programado a tiempo'),
('LH104', 'Cancelado', '2023-10-16 17:00:00', 'Situación de emergencia en aeropuerto'),
('AF105', 'Retrasado', '2023-10-17 10:30:00', 'Demora en el despegue'),
('NZ106', 'En hora', '2023-10-18 13:00:00', 'Vuelo sin problemas'),
('EK107', 'Cancelado', '2023-10-19 20:15:00', 'Problemas de seguridad');

ALTER TABLE flights ADD PRIMARY KEY (id);
ALTER TABLE reservations ADD PRIMARY KEY (id);
ALTER TABLE users ADD PRIMARY KEY (id);
ALTER TABLE airports ADD PRIMARY KEY (id);
ALTER TABLE airlines ADD PRIMARY KEY (id);
ALTER TABLE baggage ADD PRIMARY KEY (id);
ALTER TABLE flight_history ADD PRIMARY KEY (id);

ALTER TABLE flights MODIFY id int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
ALTER TABLE reservations MODIFY id int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
ALTER TABLE users MODIFY id int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
ALTER TABLE airports MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE airlines MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE baggage MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE flight_history MODIFY id int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE flights
    ADD CONSTRAINT fk_departure_airport FOREIGN KEY (departure_airport_id) REFERENCES airports (id),
    ADD CONSTRAINT fk_arrival_airport FOREIGN KEY (arrival_airport_id) REFERENCES airports (id),
    ADD CONSTRAINT fk_airline FOREIGN KEY (airline_id) REFERENCES airlines (id);

ALTER TABLE reservations
    ADD CONSTRAINT fk_user_reservation FOREIGN KEY (user_id) REFERENCES users (id),
    ADD CONSTRAINT fk_flight_reservation FOREIGN KEY (flight_id) REFERENCES flights (id);

ALTER TABLE baggage
    ADD CONSTRAINT fk_reservation_baggage FOREIGN KEY (reservation_id) REFERENCES reservations (id);

ALTER TABLE flight_history
    ADD CONSTRAINT fk_flight_history FOREIGN KEY (flight_id) REFERENCES flights (id);