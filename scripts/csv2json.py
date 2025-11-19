#!/usr/bin/env python3

import csv
import json
import os
import sys
import argparse


def csv_to_json(input_file, output_file, delimiter, has_header, encoding, field_names):
    """Convert CSV/TSV file to JSON array."""
    rows = []

    with open(input_file, 'r', encoding=encoding) as file:
        if has_header:
            reader = csv.DictReader(file, delimiter=delimiter)
            for row in reader:
                rows.append(row)
        elif field_names:
            reader = csv.DictReader(file, delimiter=delimiter, fieldnames=field_names)
            for row in reader:
                rows.append(row)
        else:
            reader = csv.reader(file, delimiter=delimiter)
            for row in reader:
                rows.append(row)

    output_directory = os.path.dirname(output_file)
    if output_directory:
        os.makedirs(output_directory, exist_ok=True)

    with open(output_file, 'w', encoding='utf-8') as file:
        json.dump(rows, file, indent=2, ensure_ascii=False)
        file.write('\n')


def main():
    parser = argparse.ArgumentParser(description='Convert CSV/TSV files to JSON')
    parser.add_argument('input', help='Input CSV/TSV file')
    parser.add_argument('output', help='Output JSON file')
    parser.add_argument('-d', '--delimiter', default=',', help='Field delimiter (default: comma)')
    parser.add_argument('--tab', action='store_true', help='Use tab as delimiter (shortcut for -d $\'\\t\')')
    parser.add_argument('--no-header', action='store_true', help='First line is not a header (output as array of arrays)')
    parser.add_argument('-e', '--encoding', default='utf-8', help='Input file encoding (default: utf-8)')
    parser.add_argument('--field-names', help='Comma-separated field names (use with --no-header to create objects)')

    args = parser.parse_args()

    delimiter = '\t' if args.tab else args.delimiter
    has_header = not args.no_header
    field_names = args.field_names.split(',') if args.field_names else None

    csv_to_json(args.input, args.output, delimiter, has_header, args.encoding, field_names)


if __name__ == '__main__':
    main()
