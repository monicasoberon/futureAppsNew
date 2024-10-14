import pdfplumber
import json

# Path to the PDF file
pdf_path = "backEnd\\jsonify\\tesisFinal1.pdf"

# List to hold the extracted data
data = []


# Open the PDF file
with pdfplumber.open(pdf_path) as pdf:
    for page in pdf.pages:
        # Extract the tables from the page
        tables = page.extract_table()

        if tables:
            # Skip the first row (header row)
            for row in tables[1:]:
                # Ensure the row has at least the number of expected columns
                if len(row) >= 5:
                    # Extract the relevant columns (ignoring the first one)
                    registro_digital = row[1]
                    precedente = row[2]
                    rubro = row[3]
                    localizacion = row[4]
                    
                    # Add the extracted data to the list
                    data.append({
                        "Registro digital": registro_digital,
                        "Tesis": tesis,
                        "Rubro": rubro,
                        "Localización": localizacion
                    })

# Save the data to a JSON file
output_json = "tesis_list.json"
with open(output_json, "w", encoding="utf-8") as json_file:
    json.dump(data, json_file, ensure_ascii=False, indent=4)

print(f"Data has been saved to {output_json}")
