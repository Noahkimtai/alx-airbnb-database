## Step 1 First Normal Form (1NF)

**Rule:**  
To achieve 1NF each column should contain **atomic (indivisible)** values, and each record must be unique.

**How it applies:**
- Each table has a **primary key** (`user_id`, `property_id`, etc.), ensuring uniqueness.
- No repeating groups or multi-valued attributes.
- Example:
  - `User` table stores a single `email` and `phone_number` per user (not multiple values in one field).
  - `Booking` has separate `start_date` and `end_date` columns —t no list or range type used.

**Schema satisfies 1NF**.


## Step 2 Second Normal Form (2NF)

**Rule:**  
A table is in 2NF if:
1. It’s already in 1NF, and  
2. **All non-key attributes depend on the entire primary key**, not part of it.

**How it applies:**
- Every table’s primary key is a single column (`UUID`), not a composite key.
- Therefore, all attributes depend entirely on that single key.

Example:
- In the `Booking` table:
  - Attributes like `start_date`, `end_date`, and `status` depend on `booking_id` (the full key), not partially.
- In the `Property` table:
  - `name`, `location`, and `price_per_night` all depend fully on `property_id`.

**Schema satisfies 2NF**.


## Step 3 Third Normal Form (3NF)

**Rule:**  
A table is in 3NF if:
1. It’s already in 2NF, and  
2. **All non-key attributes are non-transitively dependent on the primary key.**

In simpler terms, **no attribute depends on another non-key attribute**.

**How it applies:**

### User Table
- Primary Key: `user_id`
- Non-key attributes: `first_name`, `last_name`, `email`, `password_hash`, `phone_number`, `role`, `created_at`
- None of these depend on each other; all depend solely on `user_id`.
- `email` is unique but does not determine any other attribute → satisfies 3NF.

### Property Table
- Primary Key: `property_id`
- Foreign Key: `host_id` → references `users(user_id)`
- All non-key attributes (`name`, `description`, `location`, `price_per_night`, etc.) depend only on `property_id`.
- The host’s details are not repeated retrieved via `host_id` join to the `users` table.

### Booking Table
- Primary Key: `booking_id`
- Foreign Keys: `property_id`, `user_id`
- Non-key attributes like `start_date`, `end_date`, `status`, and `total_price` depend directly on `booking_id`.
- No transitive dependencies such as storing property name or host info they are referenced via relationships.

### Payment Table
- Primary Key: `payment_id`
- Foreign Key: `booking_id`
- Non-key attributes (`amount`, `payment_method`, `payment_date`) depend solely on `payment_id`.
- Payment information is not duplicated in other tables normalization prevents data inconsistency.

### Review Table
- Primary Key: `review_id`
- Foreign Keys: `property_id`, `user_id`
- Non-key attributes (`rating`, `comment`, `created_at`) depend directly on `review_id`.
- The relationship ensures user and property info are retrieved via joins, not stored redundantly.

### Message Table
- Primary Key: `message_id`
- Foreign Keys: `sender_id`, `recipient_id`
- Attributes like `message_body` and `sent_at` depend directly on `message_id`.
- No dependency on sender or recipient attributes.

**Schema satisfies 3NF**, as:
- No partial dependencies (single-column primary keys).
- No transitive dependencies (no column depends on another non-key column).
- All relationships are maintained via **foreign keys**, not by data duplication.

## Conclusion

The database schema  adheres to **Third Normal Form (3NF)**:
- Each table represents one clear entity.
- Relationships are maintained through **foreign keys**, not redundant attributes.
- Every non-key attribute depends directly and only on its table’s primary key.
