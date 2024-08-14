INSERT INTO evchargeschema.users (username, email, password, active, created, role, wallet)
VALUES
  ('admin', 'admin@gmail.com', '$2b$10$fsyj8SNc7gBxAphX9NZZLuyhX7jHnYKyjVuPSXhOvuUSUHYpY3O2y', true, CURRENT_TIMESTAMP, 'admin', 0),
  ('mmarkic', 'airtest3211@gmail.com', '$2b$10$7CRa3Vahzqcxla3/U62ORum6PnQa3zj9hEcj/QkPRryntsZyx53m6', true, CURRENT_TIMESTAMP, 'user', 0),
  ('ivoivic', 'iivic@gmail.com', '$2b$10$AZIJwdog9QAwsjwPaGNnz.b8pF/UmkHfCTh0colSXIsyqVt6FC3T.', true, CURRENT_TIMESTAMP, 'user', 0);

INSERT INTO evchargeschema.charger (name, latitude, longitude, created, creator, lastsync, active, occupied)
VALUES
  ('Charger1', 46.3075, 16.3382, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, true),
  ('Charger2', 46.2872, 16.3212, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, true),
  ('Charger3', 46.2919, 16.3423, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, true),
  ('Charger4', 46.3191, 16.3139, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, false),
  ('Charger5', 46.3090, 16.3486, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, false, false),
  ('Charger6', 46.3041, 16.3344, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, false, false),
  ('Charger7', 46.3053, 16.3356, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, false),
  ('Charger8', 46.3059, 16.3323, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, false),
  ('Charger9', 46.3108, 16.3381, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, true),
  ('Charger10', 46.3105, 16.3377, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, true, true);

INSERT INTO evchargeschema.event (charger_id, starttime, endtime, chargetime, volume, price, user_id)
VALUES
  (1, '2023-01-01 12:00:00', '2023-01-01 13:00:00', '01:00:00'::interval, 30.5, 15.45, 2),
  (2, '2023-01-02 10:00:00', '2023-01-02 11:30:00', '01:30:00'::interval, 45.0, 16.50, 3),
  (2, '2023-01-04 13:00:00', '2023-01-04 15:00:00', '02:00:00'::interval, 65.0, 20.84, 3),
  (2, '2023-01-06 10:00:00', '2023-01-06 11:30:00', '01:30:00'::interval, 15.0, 16.50, 2),
  (2, '2023-01-08 10:00:00', '2023-01-08 11:30:00', '01:30:00'::interval, 17.0, 16.50, 2);

INSERT INTO evchargeschema.card (user_id, value, active)
VALUES
  (3, 'kartica1', true),
  (2, 'kartica2', true);


