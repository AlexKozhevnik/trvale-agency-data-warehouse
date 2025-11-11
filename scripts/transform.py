# ITO Excel to CSV Preprocessor (`load.py`)

## Overview
This Python script reads an Excel file (`ito_09.xlsx`) containing booking data from the ITO system, renames columns to a standardized English naming convention, and exports the cleaned data to a UTF-8 encoded CSV file with semicolon (`;`) delimiters.

The output CSV is optimized for bulk loading into **SQL Server** using `BULK INSERT`, ensuring compatibility with:
- UTF-8 encoding (`CODEPAGE = '65001'`)
- Semicolon field separation
- Minimal quoting (`QUOTE_MINIMAL`)
- Windows line endings (`\r\n`)

---

import pandas as pd
import csv
from unidecode import unidecode

file_xlsx = r"C:\Users\PC\astra_project\new_files\ito_09.xlsx"
file_csv_safe = r"C:\Users\PC\astra_project\ready_file\ito_cleaned.csv"

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

# --- Clean 'tourists' column ---
if "tourists" in ito_final_df.columns:
    ito_final_df["tourists"] = (
        ito_final_df["tourists"]
        .astype(str)
        .str.strip()
        .str.replace(r'\s+', ' ', regex=True)
        .apply(unidecode)
    )

# --- Save cleaned CSV ---
ito_final_df.to_csv(file_csv_safe, index=False, sep=';', encoding='utf-8', quoting=csv.QUOTE_MINIMAL)

print("File cleaned and saved successfully:", file_csv_safe)
