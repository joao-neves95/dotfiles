from nevespy.fs.pdf import read_pdf_file_pages
from nevespy.fs.csv import write_csv_file

from credit import (
    convert_activobank_credit_row_to_gnucash_csv_row,
    extract_credit_statement_table_rows,
)
from debit import (
    convert_activobank_debit_row_to_gnucash_csv_row,
    extract_debit_statement_table_rows,
)


def main():
    print("Reading .pdf file...")

    # Extrato combinado.
    # One page:
    # all_pdf_pages = read_pdf_file_pages("./data/EXTRATO COMBINADO 2023007.pdf")
    # Two pages:
    # all_pdf_pages = read_pdf_file_pages("./data/EXTRATO COMBINADO 2023011.pdf")
    # all_pdf_pages = read_pdf_file_pages(
    #     "./data/EXT  AUTONOMO CARTAO (DOC 202300005).pdf"
    # )

    all_pdf_pages = read_pdf_file_pages(
        # "C:/Users/joao9/Desktop/temp/s/2024/EXT  AUTONOMO CARTAO (DOC 202400003).pdf"
        "C:/Users/joao9/Desktop/temp/s/2024/EXTRATO COMBINADO 2024003.pdf"
    )

    print("File read.")

    is_debit_statement = all_pdf_pages[0].find("\nEXTRATO COMBINADO\n") > -1

    print("Extracting all transactions...")

    all_rows = (
        extract_debit_statement_table_rows(all_pdf_pages)
        if is_debit_statement
        else extract_credit_statement_table_rows(all_pdf_pages)
    )

    print(f"{len(all_rows)} transactions extracted.")

    # print("\n".join(all_rows))

    print("Building CSV file...")

    csv = [["Date", "Deposit", "Description"]]

    for row in all_rows:
        parsed_row = (
            convert_activobank_debit_row_to_gnucash_csv_row(row)
            if is_debit_statement
            else convert_activobank_credit_row_to_gnucash_csv_row(row)
        )

        csv.append(parsed_row)

    print(f"CSV file with {len(csv) - 1} transactions created. All ready to write.")

    print("Writing CSV file...")

    write_csv_file("./data/activobankToGnuCash_tx", csv)

    print("File written.")

    print(csv)

    print("Done")

    return


# end def


main()
