
INSERT INTO users (first_name, last_name, email, password_hash, phone_number, role)
VALUES
('Alice', 'Johnson', 'alice.johnson@example.com', 'hash_pw_1', '1234567890', 'guest'),
('Bob', 'Smith', 'bob.smith@example.com', 'hash_pw_2', '9876543210', 'host'),
('Carol', 'Davis', 'carol.davis@example.com', 'hash_pw_3', '5554443333', 'guest'),
('David', 'Brown', 'david.brown@example.com', 'hash_pw_4', '4443332222', 'host'),
('Eve', 'Miller', 'eve.miller@example.com', 'hash_pw_5', '3332221111', 'guest'),
('Frank', 'Wilson', 'frank.wilson@example.com', 'hash_pw_6', '2221110000', 'host'),
('Grace', 'Taylor', 'grace.taylor@example.com', 'hash_pw_7', '1110009999', 'guest'),
('Hank', 'Anderson', 'hank.anderson@example.com', 'hash_pw_8', '9998887777', 'host'),
('Ivy', 'Thomas', 'ivy.thomas@example.com', 'hash_pw_9', '8887776666', 'guest'),
('Jack', 'White', 'jack.white@example.com', 'hash_pw_10', '7776665555', 'admin');

INSERT INTO properties (host_id, name, description, location, price_per_night)
SELECT user_id,
       name,
       description,
       location,
       price
FROM (
    VALUES
    ('Cozy Cottage', 'Small countryside cottage', 'Nairobi', 75.00),
    ('Urban Apartment', 'Modern apartment in the city center', 'Mombasa', 120.00),
    ('Beachfront Villa', 'Villa with ocean view', 'Diani', 250.00),
    ('Mountain Cabin', 'Cabin surrounded by nature', 'Mt. Kenya', 90.00),
    ('Safari Lodge', 'Luxury lodge with wildlife view', 'Maasai Mara', 300.00),
    ('Studio Flat', 'Compact and affordable studio', 'Kisumu', 60.00),
    ('Garden Bungalow', 'Bungalow with private garden', 'Nakuru', 110.00),
    ('Modern Loft', 'Stylish loft apartment', 'Eldoret', 130.00),
    ('Seaside Cottage', 'Quiet cottage near the beach', 'Malindi', 150.00),
    ('City Condo', 'High-rise condo with skyline view', 'Nairobi', 200.00)
) AS props(name, description, location, price)
JOIN (
    SELECT user_id, ROW_NUMBER() OVER () AS rn
    FROM users
    WHERE role = 'host'
) hosts ON hosts.rn <= 10;


INSERT INTO bookings (property_id, user_id, start_date, end_date, total_price, status)
SELECT
    p.property_id,
    u.user_id,
    CURRENT_DATE + (i * INTERVAL '1 day'),
    CURRENT_DATE + ((i + 3) * INTERVAL '1 day'),
    (p.price_per_night * 3),
    (ARRAY['pending', 'confirmed', 'canceled'])[1 + (i % 3)]
FROM properties p
JOIN users u ON u.role = 'guest'
CROSS JOIN generate_series(1,10) AS g(i)
WHERE p.property_id IN (
    SELECT property_id FROM properties LIMIT 10
)
LIMIT 10;


INSERT INTO payments (booking_id, amount, payment_method)
SELECT
    b.booking_id,
    b.total_price,
    (ARRAY['credit_card', 'paypal', 'stripe'])[1 + (row_number() OVER ()) % 3]
FROM bookings b
LIMIT 10;


INSERT INTO reviews (property_id, user_id, rating, comment)
SELECT
    p.property_id,
    u.user_id,
    (1 + (row_number() OVER ()) % 5),
    'Wonderful experience! Would stay again.'
FROM properties p
JOIN users u ON u.role = 'guest'
LIMIT 10;


INSERT INTO messages (sender_id, recipient_id, message_body)
SELECT
    s.user_id,
    r.user_id,
    'Hello, is this property available for next weekend?'
FROM users s
JOIN users r ON s.user_id <> r.user_id
LIMIT 10;

