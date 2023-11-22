INSERT INTO evchargeschema.users (username, email, password, active, created, role)
VALUES
  ('admin', 'admin@gmail.com', 'admin123', true, CURRENT_TIMESTAMP, 'admin'),
  ('mmarkic', 'mmarkic@gmail.com', 'mmarkic1', true, CURRENT_TIMESTAMP, 'user'),
  ('ivoivic', 'iivic@gmail.com', 'ivic321', true, CURRENT_TIMESTAMP, 'user');

INSERT INTO evchargeschema.charger (name, latitude, longitude, created, creator, lastsync)
VALUES
  ('Charger1', 40.7128, -74.0060, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP),
  ('Charger2', 34.0522, -118.2437, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP),
  ('Charger3', 50.5485, -115.2437, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP),
  ('Charger4', 26.1415, -114.1425, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP),
  ('Charger5', 34.0522, -117.2437, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP);

INSERT INTO evchargeschema.event (charger_id, starttime, endtime, volume, user_id)
VALUES
  (1, '2023-01-01 12:00:00', '2023-01-01 13:00:00', 30.5, 2),
  (2, '2023-01-02 10:00:00', '2023-01-02 11:30:00', 45.0, 3),
  (2, '2023-01-04 13:00:00', '2023-01-04 15:00:00', 65.0, 3),
  (2, '2023-01-06 10:00:00', '2023-01-06 11:30:00', 15.0, 2),
  (2, '2023-01-08 10:00:00', '2023-01-08 11:30:00', 17.0, 2);

INSERT INTO evchargeschema.card (user_id, value, active)
VALUES
  (3, 50000, true),
  (2, 25000, true);


