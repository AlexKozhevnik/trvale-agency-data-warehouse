# Data Catalog for Gold Layer

## Overview
The **Gold Layer** contains business-ready, analytical data structured to support reporting and decision-making.  
It consists of **dimension tables** and a **fact table** representing key business metrics.

---

## 1. `gold.dim_agencies`
**Purpose:** Travel agencies partnering with the company.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| agency_key | INT | Surrogate key |
| agency_name | NVARCHAR(100) | Agency name |

---

## 2. `gold.dim_cities`
**Purpose:** Cities where the hotels are located.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| city_key | INT | Surrogate key |
| city | NVARCHAR(50) | City name |

---

## 3. `gold.dim_companies`
**Purpose:** Companies used for invoicing.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| company_key | INT | Surrogate key |
| company_name | NVARCHAR(50) | Company name |

---

## 4. `gold.dim_currencies`
**Purpose:** Currencies used for invoicing.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| currency_key | INT | Surrogate key |
| currency_name | NVARCHAR(20) | Currency code (e.g., USD, CZK, EUR) |

---

## 5. `gold.dim_customers`
**Purpose:** End customers staying at hotels.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| customer_key | INT | Surrogate key |
| customer | NVARCHAR(100) | Full name |

---

## 6. `gold.dim_date`
**Purpose:** Calendar dimension used to simplify filtering and analysis by date.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| date_key | INT | Surrogate key (recommended format `YYYYMMDD`) |
| full_date | DATE | Full date |
| calendar_year | INT | Year |
| calendar_quarter | INT | Quarter |
| calendar_month | INT | Month number |
| month_name_cz | NVARCHAR(20) | Month name (Czech) |
| day_of_week_id | INT | Day of week number |
| day_of_week_cz | NVARCHAR(20) | Day of week (Czech) |
| day_of_week_short_cz | NVARCHAR(10) | Abbreviated day of week (Czech) |
| is_weekend | BIT | 1 – weekend, 0 – working day |
| is_current_day | BIT | 1 – current day, 0 – otherwise |

---

## 7. `gold.dim_hotels`
**Purpose:** Hotels cooperating with the travel agency.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| hotel_key | INT | Surrogate key |
| hotel_name | NVARCHAR(50) | Hotel name |

---

## 8. `gold.dim_managers`
**Purpose:** Managers who enter bookings into the reservation system.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| manager_key | INT | Surrogate key |
| manager_name | NVARCHAR(100) | Manager name |
| is_active | BIT | 1 – active within the last 90 days, 0 – inactive |

---

## 9. `gold.dim_meal_type`
**Purpose:** Meal types reserved by customers.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| meal_type_key | INT | Surrogate key |
| meal_type_name | NVARCHAR(50) | Meal type name |

---

## 10. `gold.dim_order_status`
**Purpose:** Reservation status types.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| status_key | INT | Surrogate key |
| status_name | NVARCHAR(50) | Reservation status (e.g., New, Not Confirmed, Confirmed, Pending, Cancelled) |

---

## 11. `gold.dim_payment_types`
**Purpose:** Payment methods.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| payment_key | INT | Surrogate key |
| payment_name | NVARCHAR(100) | Payment type name |

---

## 12. `gold.dim_rooms`
**Purpose:** Hotel room types.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| room_key | INT | Surrogate key |
| room_name | NVARCHAR(100) | Room type |

---

## 13. `gold.dim_services`
**Purpose:** Services offered by the travel agency.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| service_key | INT | Surrogate key |
| service_type | NVARCHAR(50) | Service type (e.g., accommodation, transfer) |

---

## 14. `gold.fact_bookings`
**Purpose:** Booking-level fact table containing metrics and references to related dimensions.

| Column name | Data Type | Description |
|-------------|-----------|-------------|
| booking_fact_key | INT | Surrogate key |
| service_key | INT | FK → `gold.dim_services` |
| hotel_key | INT | FK → `gold.dim_hotels` |
| city_key | INT | FK → `gold.dim_cities` |
| room_key | INT | FK → `gold.dim_rooms` |
| meal_type_key | INT | FK → `gold.dim_meal_type` |
| agency_key | INT | FK → `gold.dim_agencies` |
| customer_key | INT | FK → `gold.dim_customers` |
| status_key | INT | FK → `gold.dim_order_status` |
| manager_key | INT | FK → `gold.dim_managers` |
| booked_date_key | INT | FK → `gold.dim_date` |
| check_in_date_key | INT | FK → `gold.dim_date` |
| check_out_date_key | INT | FK → `gold.dim_date` |
| free_cancel_date_key | INT | FK → `gold.dim_date` |
| currency_key | INT | FK → `gold.dim_currencies` |
| payment_key | INT | FK → `gold.dim_payment_types` |
| company_key | INT | FK → `gold.dim_companies` |
| due_date_key | INT | FK → `gold.dim_date` |
| payment_date_key | INT | FK → `gold.dim_date` |
| total_nights | INT | Number of hotel nights |
| pax | INT | Number of guests |
| net_price | DECIMAL(18,2) | Price paid by the agency to the hotel |
| agency_price | DECIMAL(18,2) | Price charged by the agency |
| invoice_sum | DECIMAL(18,2) | Invoice amount to the customer |
| paid | DECIMAL(18,2) | Paid amount |
| outstanding_amount | DECIMAL(18,2) | Remaining amount to be paid before `due_date_key` |
| profit | DECIMAL(18,2) | Financial profit per booking |
| number | NVARCHAR(50) | Sequential reservation number |
| reservation_number | NVARCHAR(50) | System reservation ID |
| common_number | NVARCHAR(50) | Unique reservation identifier |
| notes | NVARCHAR(250) | Manager notes |
| invoice_number | NVARCHAR(250) | Invoice ID provided to the customer |
| invoice_proforma | NVARCHAR(250) | Proforma invoice ID |
| invoice_total | NVARCHAR(250) | Final accounting invoice ID |

---

End of document.
