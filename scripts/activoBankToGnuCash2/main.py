from datetime import datetime
from typing import Iterable

from nevespy.fs.pdf import read_pdf_file_pages
from nevespy import lists

import helpers


def main():
    # Extrato combinado.
    # One page:
    # all_pdf_pages = read_pdf_file_pages("./data/EXTRATO COMBINADO 2023007.pdf")
    # Two pages:
    all_pdf_pages = read_pdf_file_pages("./data/EXTRATO COMBINADO 2023011.pdf")
    # all_pdf_pages = read_pdf_file_pages(
    #     "./data/EXT  AUTONOMO CARTAO (DOC 202300005).pdf"
    # )
    is_debit_statement = all_pdf_pages[0].find("\nEXTRATO COMBINADO\n") > -1

    # TODO: add logs.

    all_rows = (
        extract_debit_statement_table_rows(all_pdf_pages)
        if is_debit_statement
        else extract_credit_statement_table_rows(all_pdf_pages)
    )

    print("\n".join(all_rows))

    csv = [["Date", "Deposit", "Description"]]

    for row in all_rows:
        parsed_row = (
            convert_activobank_debit_row_to_gnucash_csv_row(row)
            if is_debit_statement
            else convert_activobank_credit_row_to_gnucash_csv_row(row)
        )
        csv.append(parsed_row)

    print(csv)

    return


def extract_debit_statement_table_rows(sub_pages: Iterable[str]) -> Iterable[str]:
    all_movements = []

    for page in sub_pages:
        table_start_idx_inclusive = helpers.find_and_increment_idx(
            page, 0, "SALDO INICIAL"
        )

        if table_start_idx_inclusive == -1:
            # Try second page:
            table_start_idx_inclusive = helpers.find_and_increment_idx(
                page, 0, "TRANSPORTE"
            )

            if table_start_idx_inclusive == -1:
                # This is a page without a table.
                continue

        table_start_idx_inclusive = helpers.find_and_increment_idx(
            page, table_start_idx_inclusive, "\n"
        )

        table_start_idx_inclusive += 1

        last_page_table_end = helpers.find_and_increment_idx(
            page, table_start_idx_inclusive, "A TRANSPORTAR"
        )

        if last_page_table_end == -1:
            last_page_table_end = helpers.find_and_increment_idx(
                page, table_start_idx_inclusive, "SALDO FINAL"
            )

            if last_page_table_end == -1:
                table_end_idx_exclusive = len(page)
            else:
                table_end_idx_exclusive = last_page_table_end
        else:
            table_end_idx_exclusive = last_page_table_end

        page_movements = lists.strip_str_list(
            page[table_start_idx_inclusive:table_end_idx_exclusive].split("\n")
        )

        # For some reason, ActivoBank adds a '\n' after the dates of the first row.
        page_movements[1] = page_movements[0] + " " + page_movements[1]
        page_movements = page_movements[1:]

        all_movements.extend(page_movements)
    # end for

    return all_movements


def extract_credit_statement_table_rows(sub_pages: Iterable[str]) -> Iterable[str]:
    all_movements = []

    for page in sub_pages:
        table_start_idx_inclusive = helpers.find_and_increment_idx(
            page, 0, "Valor Descritivo Rede Débito Crédito"
        )

        if table_start_idx_inclusive == -1:
            # This is a page without a table.
            continue

        table_start_idx_inclusive = helpers.find_and_increment_idx(
            page, table_start_idx_inclusive, "\n"
        )

        table_end_idx_exclusive = len(page)

        page_movements = page[table_start_idx_inclusive:table_end_idx_exclusive]
        page_movements = helpers.split_str_by_re(
            page_movements, r"\n\d{4}/\d{2}/\d{2} "
        )
        page_movements = lists.replace_in_str_list(page_movements, "\n", " ")

        for i in range(0, len(page_movements), 2):
            page_movements[i] = page_movements[i].lstrip()
            page_movements[i] = page_movements[i] + page_movements[i + 1]
        # end for

        all_movements.extend(page_movements)
    # end for

    return all_movements


def convert_activobank_credit_row_to_gnucash_csv_row(row: str) -> Iterable[str]:
    """
    Args:
        row (str): "yyyy/mm/dd yyyy/mm/dd This is the description 420.69 MB"
    """
    row_parts = row.split(" ")
    move_date = row_parts[0]
    movement_value = row_parts[-2]
    description = " ".join(row_parts[2:-2])

    return [move_date, movement_value, description]


def convert_activobank_debit_row_to_gnucash_csv_row(row: str) -> Iterable[str]:
    """
    Args:
        row (str): "mm.dd mm.dd This is the description 420.69 42 069.69"
    """
    row_parts = row.split(" ")
    move_date = str(datetime.now().year) + "/" + row_parts[0].replace(".", "/")

    values = []
    count = 0
    last_value_part_idx = len(row_parts)
    for row_part_idx in reversed(range(0, len(row_parts))):
        last_value_part_idx = row_part_idx
        row_part = row_parts[row_part_idx]

        if "." not in row_part and row_part.isdigit():
            values[count] = row_part + values[count]
            count += 1
        else:
            if not row_part[0].isdigit() or not row_part[len(row_part) - 1].isdigit():
                break
            values.append(row_part)

        if count == 2:
            break
    # end for

    last_value_part_idx += 1

    movement_value = values[1]
    description = " ".join(row_parts[2:last_value_part_idx])

    return [move_date, movement_value, description]


main()
