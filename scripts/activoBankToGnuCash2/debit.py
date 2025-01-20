from typing import Iterable

from nevespy import lists

import helpers


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


# end def


def convert_activobank_debit_row_to_gnucash_csv_row(row: str) -> Iterable[str]:
    """
    Args:
        row (str): "mm.dd mm.dd This is the description 420.69 42 069.69"
    """
    row_parts = row.split(" ")
    move_date = str(helpers.get_current_year()) + "/" + row_parts[0].replace(".", "/")

    last_part_idx = len(row_parts)
    for row_part_from_end_index in reversed(range(0, len(row_parts))):
        last_part_idx = row_part_from_end_index
        row_part = row_parts[row_part_from_end_index]

        if "." not in row_part:
            if row_part.isdigit() and len(row_part) <= 3:
                continue
            else:
                break
        else:
            # E.g.: "420.69"
            # Check first and last characters only.
            if not row_part[0].isdigit() or not row_part[-1].isdigit():
                break
            else:
                continue
    # end for

    transaction_value = ""

    for part in row_parts[last_part_idx + 1 :]:
        if "." in part:
            transaction_value += part.strip()
            # Break on the first decimal point found.
            break
        if part.isdigit():
            transaction_value += part.strip()
            continue
        else:
            break

    description = " ".join(row_parts[2 : last_part_idx + 1])

    return [move_date, transaction_value, description]


# end def
