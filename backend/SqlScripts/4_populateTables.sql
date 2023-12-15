INSERT INTO evchargeschema.users (username, email, password, active, created, role)
VALUES
  ('admin', 'admin@gmail.com', 'admin123', true, CURRENT_TIMESTAMP, 'admin'),
  ('mmarkic', 'mmarkic@gmail.com', 'mmarkic1', true, CURRENT_TIMESTAMP, 'user'),
  ('ivoivic', 'iivic@gmail.com', 'ivic321', true, CURRENT_TIMESTAMP, 'user');

INSERT INTO evchargeschema.charger (name, latitude, longitude, created, creator, lastsync, active, occupied)
VALUES
  ('Charger1', 40.7128, -74.0060, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, true),
  ('Charger2', 34.0522, -118.2437, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, true),
  ('Charger3', 50.5485, -115.2437, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, true),
  ('Charger4', 26.1415, -114.1425, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, false),
  ('Charger5', 34.0522, -117.2437, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, false, false);

INSERT INTO evchargeschema.event (charger_id, starttime, endtime, chargetime, volume, price, user_id)
VALUES
  (1, '2023-01-01 12:00:00', '2023-01-01 13:00:00', '01:00:00'::interval, 30.5, 15.45, 2),
  (2, '2023-01-02 10:00:00', '2023-01-02 11:30:00', '01:30:00'::interval, 45.0, 16.50, 3),
  (2, '2023-01-04 13:00:00', '2023-01-04 15:00:00', '02:00:00'::interval, 65.0, 20.84, 3),
  (2, '2023-01-06 10:00:00', '2023-01-06 11:30:00', '01:30:00'::interval, 15.0, 16.50, 2),
  (2, '2023-01-08 10:00:00', '2023-01-08 11:30:00', '01:30:00'::interval, 17.0, 16.50, 2);

INSERT INTO evchargeschema.card (user_id, value, active)
VALUES
  (3, 50000, true),
  (2, 25000, true);


