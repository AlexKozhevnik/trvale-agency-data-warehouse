# ITO Excel to CSV Preprocessor (`ito_cleaner.py`)

## Overview
This Python script reads an Excel file (`ito_09.xlsx`) containing booking data from the ITO system, renames columns to a standardized English naming convention, and exports the cleaned data to a UTF-8 encoded CSV file with semicolon (`;`) delimiters.

The output CSV is optimized for bulk loading into **SQL Server** using `BULK INSERT`, ensuring compatibility with:
- UTF-8 encoding (`CODEPAGE = '65001'`)
- Semicolon field separation
- Minimal quoting (`QUOTE_MINIMAL`)
- Windows line endings (`\r\n`)

---

## Purpose
Used in the **ETL pipeline (Bronze Layer)** to:
- Extract raw data from Excel
- Transform column names for consistency
- Load into `bronze.ito` table via `BULK INSERT`

---

## Input
- **File**: `ito_09.xlsx`
- **Path**: `C:\Users\PC\astra_project\ito_09.xlsx`
- **Sheet**: `List1`
- **Engine**: `openpyxl`

---

## Output
- **File**: `ito_09_cleaned_safe.csv`
- **Path**: `C:\Users\PC\astra_project\ito_09_cleaned_safe.csv`
- **Format**:
  - Delimiter: `;`
  - Encoding: `UTF-8`
  - Quoting: `QUOTE_MINIMAL`
  - Index: excluded
  - Line endings: Windows (`\r\n`)

---

import pandas as pd
import csv

file_xlsx = r"C:\Users\PC\astra_project\ito_09.xlsx"
file_csv_safe = r"C:\Users\PC\astra_project\ito_09_cleaned_safe.csv"

ito_df = pd.read_excel(file_xlsx, sheet_name="List1", engine="openpyxl")

# Rename columns
ito_final_df = ito_df.rename(columns={
    "№":"number",
    "Resv.Nr.": "reservation_number",
    "Common Nr.": "common_number",
    "Booked": "booked",
    "C/in": "check_in",
    "C/out": "check_out",
    "Pax": "pax",
    "City": "city",
    "Hotel": "hotel",
    "Room category": "room_category",
    "Meal type": "meal_type",
    "Notes": "notes",
    "R.N.": "rn",
    "Agency": "agency",
    "Tourists": "tourists",
    "State": "status",
    "T/O Ref. Nr.": "ref_number",
    "Free cancel till": "free_cancel_till",
    "Net": "netto_price",
    "Price": "price",
    "Agency price": "agency_price",
    "Invoice number": "invoice_number",
    "Invoice proforma": "invoice_proforma",
    "Invoice total": "invoice_total",
    "Invoice sum": "invoice_sum",
    "Due date": "due_date",
    "Paid":"paid",
    "Rest to pay":"rest_to_pay",
    "Currency":"currency",
    "Payment date":"payment_date",
    "Voucher nr.":"voucher_number",
    "Hotel conf nr.":"hotel_confirmation_number",
    "Legal entity":"legal_entity",
    "Booking manager":"booking_manager",
    "Payment type":"payment_type",
    "Profit":"profit"
})

# save as CSV; sep=';' for compatibility with the BULK INSERT
ito_final_df.to_csv(file_csv_safe, index=False, sep=';', encoding='utf-8', quoting=csv.QUOTE_MINIMAL)
